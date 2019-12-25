Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D3812A8F1
	for <lists+stable@lfdr.de>; Wed, 25 Dec 2019 19:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfLYSzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Dec 2019 13:55:12 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:42568 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYSzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Dec 2019 13:55:11 -0500
Received: by mail-pf1-f169.google.com with SMTP id 4so12233611pfz.9;
        Wed, 25 Dec 2019 10:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xgZFpCpNrhFu3mLOBpN710flHfnN12+ruWfczrWMT8g=;
        b=FKo2haK1ISzOlO8+Zv1z2oDimV+0dSZyGA5Wd8nsUrksp2eMwM4aIDjlRPy5Rb6E9e
         n0WSUb1eexHhYJytKOMiFnjbfLZId8dBShqXg8rkg9kShr3A3S9XB+i1G7FqDRPFEA67
         O3xMnPgxmsBWNqD8kTCMZXEH7eJgISqk6t+mR1DB3ae7TGXb7n3aZscZfYVYS5b9BeED
         jPwcsP/++hTuG4cLFfnFp/R74FIH99RC8nxCjFWDfmRAl9mm5f7MkDzJjplgjNeVY3r0
         r/hIIBpTRrO8BmKb/p+pLtCY7OgZeQ6ZZcL/BzS30St71dupQQekHAalqD/4o5pQNv6d
         vtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xgZFpCpNrhFu3mLOBpN710flHfnN12+ruWfczrWMT8g=;
        b=FGq/tzfeDIW2GgXnpqHiYJbWO5elbHq1E27hfeps4XWQeIFUMlVvORtgVWklNOvHjD
         U8LZgwnzPQ53hPmYA3SUWWgf1bPn5obozg4Gt7LU/HniTAwkc63bXv/gXwUJanbGRdRv
         IGjNQLxfhEbSqm+VoxPK1QcTqJalD5OEejdyAaOl8FhctTXoyboSuvRJcCzq6j1SHuw5
         YwZl1hv7PGILgsYheXjjxSv8EyqGnL8FAokAq4Yf4DJDL9zFezK7+WrEHEfkqmGFvhuy
         RpedgmJTtx8PvIQoGuuEtszuF/r9XhGMgp0/KcVLxtD6U58fQTJJDwMh6TqK0J28QOH2
         udtQ==
X-Gm-Message-State: APjAAAVs8Hg7UCtgT/Ixj42OpHmE5uMLGVYwgJzCVEEkT9MBvreRlztS
        vx/LAf++ZVedy1b51EzdfTlpGrAIBqRWTg==
X-Google-Smtp-Source: APXvYqw9XVRHVv2y+WPl4UDJKNClBZl2vHM2v0LvxtNCgMl15pXK6WjeW/OwxJwKsWHPpdY4Mm26+w==
X-Received: by 2002:aa7:820d:: with SMTP id k13mr46245222pfi.10.1577300111127;
        Wed, 25 Dec 2019 10:55:11 -0800 (PST)
Received: from localhost.localdomain ([2408:821b:3c17:dba0:8be:fc5e:b1bd:fb49])
        by smtp.gmail.com with ESMTPSA id y128sm32279607pfg.17.2019.12.25.10.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 10:55:10 -0800 (PST)
From:   youling257 <youling257@gmail.com>
To:     Thinh.Nguyen@synopsys.com
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@kernel.org,
        John.Youn@synopsys.com, youling257 <youling257@gmail.com>
Subject: Re: usb: dwc3: gadget: Fix request complete check
Date:   Thu, 26 Dec 2019 02:54:57 +0800
Message-Id: <20191225185457.11489-1-youling257@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <ac5a3593a94fdaa3d92e6352356b5f7a01ccdc7c.1576291140.git.thinhn@synopsys.com>
References: <ac5a3593a94fdaa3d92e6352356b5f7a01ccdc7c.1576291140.git.thinhn@synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"usb: dwc3: gadget: Fix logical condition" cause g_mass_storage not work,
test "usb: dwc3: gadget: Fix request complete check" fix the problem.
