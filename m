Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1C18F8703
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 03:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLCwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 21:52:53 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:37365 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKLCwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 21:52:53 -0500
Received: by mail-pl1-f182.google.com with SMTP id bb5so406616plb.4
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 18:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=y3Ue1urKyc3m4J2KjECf5vfi+CSA2ZMCGSoNhEstqtE=;
        b=NHDfAKqNUQpUMuf4ZU1rgB27pJjXUVKjx6FH1IXVbVeGATGRKzDeOoLB5NBxM8ZliP
         KCs4JMYnHoyRJUAtCk2SAm7N0fSzjaEJ5GaSOVuFaap38yJ83CQa3ox8BnicHFVzwRYj
         2q8PWHSeBi5QPtWeG0E+SHhW7F66e/0VbizmuqXnHoDwBaWuq0Dm7UHk0ODGE7I8PNlM
         kPNLuxCf+Biqx+RuO2b5JNRSpcdJlTrIDIz4l2ZGcSfs/35bKiDFWTbR098ocI1L5xXd
         xMQO3Dv19DVE5GgYJJwJxjkMdVfZyi0yeoEyOVaKWlQlzAAC7l+VT39ttJ3xtbkJrqYh
         Abmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=y3Ue1urKyc3m4J2KjECf5vfi+CSA2ZMCGSoNhEstqtE=;
        b=W1R7VAolPe9JHtBRLK7BOSYKxpIOtywEV2xK+TSEf9XcLwa6ekYtsxY3KHq3Qohghw
         hgtR3ewENyrnfRAQXNprR/pzuonPqSD2LtjsujRgAq8Er9mu6uKyag6MDIISkIT1Z3MR
         Kk5Bhd1O0QZ0bLPIyQfl4oVgaIclviv0gWxbNPgaficEF5iGtT8PYsUFeMWsqzwkNNA/
         clKE2SPLRGm9h28VQL0ccKOn3F1E3qP5f8WPmRqtyoHC+X5gKl2HyulAs2+j0L03D8dR
         Cggafh6zR12pjCJYerMAfO3QkdElqasZ4st5XHh2y1OybdVfkuOIPOy2VS92rQ9Zu9dU
         J5mw==
X-Gm-Message-State: APjAAAWZF8xPjKogwoiGPgX92LelqC2bZsNwzQX7S78Sjzrsd9/sHx+y
        HlGMEgpesEtfj3UwaFZD32s57b6w
X-Google-Smtp-Source: APXvYqwRO7VUDoiAgbjRpS+GELjrAXfS306tD9jB97hVXtFa1FfD+FvhqW+F33fVpUUk8oMWx3BSmA==
X-Received: by 2002:a17:902:26d:: with SMTP id 100mr30118930plc.7.1573527171436;
        Mon, 11 Nov 2019 18:52:51 -0800 (PST)
Received: from [192.168.1.101] (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id q185sm23273185pfc.153.2019.11.11.18.52.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 18:52:50 -0800 (PST)
To:     stable@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Subject: Please consider mainline commit 9393c8de628c for stable
Message-ID: <3bb75710-9e53-4896-b368-a3c5a3fc7fa8@gmail.com>
Date:   Tue, 12 Nov 2019 15:52:47 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable kernel maintainers,

please consider including commit 9393c8de628c ("scsi: core: Handle 
drivers which set sg_tablesize to zero") for inclusion in stable.

The commit fixes a long standing bug that affects all SCSI low-level 
drivers setting sg_tablesize to zero, introduced in commit d285203c 
("scsi: add support for a blk-mq based I/O path.") around kernel version 
3.16.

Use of the option use_blk_mq=y in kernel versions prior to 5.1, and any 
use of such drivers in later kernels, will result in a null pointer 
dereference from the block layer.

I hadn't expected Martin Petersen to pick my fix over another one 
submitted by Finn Thain, so I never added CC: or Fixes: tags.

Cheers,

	Michael
