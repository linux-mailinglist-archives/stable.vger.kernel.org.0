Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C804F8799
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 05:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLExP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 23:53:15 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46623 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfKLExP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 23:53:15 -0500
Received: by mail-pf1-f194.google.com with SMTP id 193so12410261pfc.13
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 20:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XEAtgRrjzfAVPsnVGPTc8lanDMdVB2ImU7SxTBAyB5Y=;
        b=a0bI2FGniS+7o9U3MYmbG1nLkcLD0Te9v0xauuLq6LVQXQ1XCGu3yInOE8R4dwY1J3
         YdEpZnvekXo2k6Eqwlr8jKHDy396uwJ1gXpzgmx3lrS8Uk9s1JBkFgpNyT+QJNxgq9au
         6iMEryB2+Q0o+2e2oOyEwinfknoD4JN5e5ZZSdU+hlW9IMUM188w+3YCP9UUI4W3ylKD
         GDOIiza1VnIPai/RXQfYIA3/RmIH8FdyxbgqY2Fyhkok1x+fn4l7XEc+x9sl1/vVyvQP
         3rvLJzB5R8mwUvNM/+5348CsnQfN63bFX3oliPRcRg/oRCCQCMCq8IsUIUX6okwXLAV0
         jkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XEAtgRrjzfAVPsnVGPTc8lanDMdVB2ImU7SxTBAyB5Y=;
        b=fMtwx6a37Z8QXLUv6rf0c5dbouF9205+UNR9mFXEzB7LBVmfG+OJj6k19wE0WdzY3K
         ec3831oxvTMsZ86bp0cgSnNAuyrI+GpaFeo+cv1OaWONhH4pGRtZUD6NgeCbJUtkIOO3
         Cq99+A9j3Li7wrJBU5DVerU7UXemW6tW4rJGQwTQvVltGVLW7i2JOD/pjodDfDNZ0Eoq
         n1pyBMcNp4Zw2bFlFIzm2aF4Zw8YiWcS3oqCzhZPeUr9RSSg6FZH+bAn2MRw6TKEWgqS
         Doku0MmB/Xu/7upF7ptl7nags2M2YxwYISguV9TzTvMVy8Tc3e6b5T7KJqByMQh0CNlM
         cmxw==
X-Gm-Message-State: APjAAAUXnwHXR/9lUDABZqD0wUUrMSTdHCHoiU+w6EsugfvNmSNXrpl2
        GBWCMEwnnVnnHAklj7OY2XpklzGAPNc=
X-Google-Smtp-Source: APXvYqxcyftoRzIf6xjeywfw/WhWswicxvWiWK0pafFF4HRf0jDSR/C4P5iGUvWa7gS0VkcRBTAqGA==
X-Received: by 2002:a17:90b:30ca:: with SMTP id hi10mr3745590pjb.143.1573534394395;
        Mon, 11 Nov 2019 20:53:14 -0800 (PST)
Received: from example.com ([128.199.164.101])
        by smtp.gmail.com with ESMTPSA id f13sm6807923pgj.87.2019.11.11.20.53.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 20:53:13 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     stable@vger.kernel.org
Subject: Re: Re: [PATCH 4.19] spi: spi-gpio: fix crash when num-chipselects is 0
Date:   Tue, 12 Nov 2019 12:53:05 +0800
Message-Id: <20191112045305.9853-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191104130725.GA2128343@kroah.com>
References: <20191104130725.GA2128343@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This part is small enough to fix the crash, why should we bother to
backport the whole thing?

Regards,
DENG Qingfang
