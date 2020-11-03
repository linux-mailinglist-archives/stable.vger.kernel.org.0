Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E913B2A3C44
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 06:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgKCFzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 00:55:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50649 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCFzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 00:55:20 -0500
Received: from mail-pl1-f197.google.com ([209.85.214.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kZpHr-0004fq-5R
        for stable@vger.kernel.org; Tue, 03 Nov 2020 05:55:19 +0000
Received: by mail-pl1-f197.google.com with SMTP id m7so7023441pls.12
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 21:55:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=AbK/zWUvmIpjrbo5g2wX98DKGLUNFBag7fCLSiUwV6A=;
        b=UlRDYX1CK+2lvJt2qisjFJSOCMFjtVCkQ1tvgSsID07pULXyIPvGqS/U9c0YkKUoJn
         tToPJVg/oqJ3FibsfN7AddMcXjRrG1H7DNAObkNGV+jspLnuqOXUtV8aOaptlE8H1kqV
         zgCxj1OGMQn/iSpMCqdKJR3+nhobxiGTUOjj7hMFjxvdXFhQacR4mUiiOBo8wEBxc/Vz
         JCDeVcjPWrqt1pecljdBmCU3qTgvyt3vkSLLtO3vDaDlaQHwXMbYYhK9Esf1UOWv2IHo
         sINQnBdrmsoPxejgUk4amE2NCZYRQgRJEmeP/Dyp/SiwleMdr7GJ71v+NDKfOuclGu+h
         gFLg==
X-Gm-Message-State: AOAM5334ktRPEpbFd4uxSK4zoMLYw9xRYW0Txft75sTE4DEMAPJlmJyr
        j12I7kE/AvPo/jsAXg3HXmdhRN4ZI/4qofGqq1uWK6qeMrFRlpm7XegdfS0ooJIUCjNeR8DgupB
        LoKUfm06GJDa8d8hEe6NywBQXm58af8Xadg==
X-Received: by 2002:a63:f1d:: with SMTP id e29mr3538346pgl.445.1604382917613;
        Mon, 02 Nov 2020 21:55:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6OCGS51kW6LHiB2B3ib0miq84C2jF0PrjkTQq4/mFe+2o9BCSLq225Si85Zpjmw9t+BED1w==
X-Received: by 2002:a63:f1d:: with SMTP id e29mr3538329pgl.445.1604382917289;
        Mon, 02 Nov 2020 21:55:17 -0800 (PST)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id u14sm4019522pfc.87.2020.11.02.21.55.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Nov 2020 21:55:16 -0800 (PST)
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Stable backport request for 44492e70adc8 ("rtw88: pci: Power cycle
 device during shutdown")
Message-Id: <747E6F28-BE7E-424B-A879-7EA9DE015DB0@canonical.com>
Date:   Tue, 3 Nov 2020 13:55:14 +0800
To:     linux-stable <stable@vger.kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please backport 44492e70adc8 to 5.4 stable.

The commit fixes broken WiFi for many users.
Currently only stable 5.4 misses this patch, older kernels don't have rtw88.

Kai-Heng
