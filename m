Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C923232459E
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 22:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhBXVMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 16:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbhBXVMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 16:12:52 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F7CC061574
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 13:12:11 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id k13so5323772ejs.10
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 13:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=InHNNoLEf6LbmBLy7uhVlMEb/v5m2oP+KjVGwHBtaRo=;
        b=PkqiPW+zxTn4u3QGGPUiKF8pCWLG7ExtgoEK76MVsRGPOF6vCSfhHLovi/BUmulJuW
         P/Ri4s18YMLz3t4B82zAcQ1ByzwgP4HtPE2gjKo2km+pQ0fSnchwe9G8oLFBJi8h+r1B
         5A7n7Pm4FXsfx23QCLb5V7sWEL3vRu1WjtWKTVs0GTVwsR8uGXOiqe8fPDqmmuNVKkUE
         +f3zN3etQ1b9JK33tRb3P76X+ejf/yu1Qd7Oc+aF95jyp9TdlBXkr2sD2IM5U4q5dDiE
         FAAPlve7BvFvp1ZeQ51617zVRV9SS6f54GTFdndYHpMecP1YEfbXdth4b2dJf1oCMSSy
         JmVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=InHNNoLEf6LbmBLy7uhVlMEb/v5m2oP+KjVGwHBtaRo=;
        b=MB49CRDoIRfzGJ8RmmDuOYcvaH4ZvKEbAqpBnNDCIXI8y52RjIVqC2JV8g5Mh+1msH
         JuzyoR2F/AEghm4a/yCLOaqHp815qxajqDkqTQetZqu14yWKBspp2+OsRSdHZbgGNAsH
         URwZcU2mpWcLOmbXue3LjPfUCEfnLwhsiwKIe4X/VnddNXhEO+ap2G8Ane2ttmtBSRKu
         Q3wEKOHAns4g4v82F2aag+Wvnd8Wg1rLAEExzQph0M7pIEFTbHiVH+9v8/EwAWs/b6D+
         ylNf5kIJMOCYID/3Yng+PhkJ9BY9NJDLkbEnDxeovecQMK/eZXKnZ3wGFEn4pY3AMgkx
         fJ3Q==
X-Gm-Message-State: AOAM533eGS/qRnc2xke+OGQyKKNfl0mflv0kog/ZHhRxfSir4uxFmtQ3
        PMuuyjMeqKyhBk6N1g4HHH808Sgi0vH07Q==
X-Google-Smtp-Source: ABdhPJyfRz/qB3HXeUbSGIVzyqnn2PIwr/1Iwd4CZEjLHLVQqDvMoMyfAXBYHbfDD2Xcgw6nXc+e+g==
X-Received: by 2002:a17:906:f2c3:: with SMTP id gz3mr33066790ejb.315.1614201130691;
        Wed, 24 Feb 2021 13:12:10 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id s18sm1901343ejc.79.2021.02.24.13.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 13:12:09 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Wed, 24 Feb 2021 22:12:08 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Hui Wang <hui.wang@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Please apply commit 234f414efd11 ("Bluetooth: btusb: Some Qualcomm
 Bluetooth adapters stop working") back to 5.10.y
Message-ID: <YDbBKBgPSytJmAl+@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Please do consider applying 234f414efd11 ("Bluetooth: btusb: Some
Qualcomm Bluetooth adapters stop working") back to 5.10.y versions.
The issue got introduced in starting in 5.10-rc1.

Greg, I realize this is for now only in mainline but not even in
released tag, so following your earlier suggestion this might as well
be delayed a bit.

In https://bugzilla.kernel.org/show_bug.cgi?id=211571,
https://bugzilla.kernel.org/show_bug.cgi?id=210681 and
https://bugs.debian.org/981005 several users indicated to be affected
and would appreciate a fix to be backported to the stable series.

Regards,
Salvatore
