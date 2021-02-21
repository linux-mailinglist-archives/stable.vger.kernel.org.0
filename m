Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB53320A48
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 13:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhBUMqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 07:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhBUMqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 07:46:53 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7794C061574
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 04:46:12 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o82so11056635wme.1
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 04:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Eim7iupkcg51eaOVYIpb7LCo2gj3r6i0bd87/z2/iPA=;
        b=LQhz9EVPlPOgjt/iwtLRvNKbhY4bNTERxg/JwNCywHvgf6HDX73Cu1mgrniir+Qra2
         DohMu45NEV7jABXCXb0tyGz1Gqr+9aYDVfaEZngtfQCSEpUhuvTMd5zQ/4t8O6MKXyAw
         sgf8oOFYFTooeWJM7E3vBAgIcn2ZWJ2OR4H7KxtOM4kjktI5SWFXqZsNr3xsRVRfNn3u
         W8x84Yc2Rcy3b42sDG4PSyr1zgmxWnUfteHALrv53K3LkY6onp09YUQ+mgkB6grjKEL2
         fYY9IcGNjmBIz9WnGMnJjYoeclAl0U1n0RmFWHc3g7rVFxUymBcIhRP8J07cuQD0zUUe
         2f1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=Eim7iupkcg51eaOVYIpb7LCo2gj3r6i0bd87/z2/iPA=;
        b=H899iNIZWd6ka3VhYsv5bNMb/Z6eNAUC+MfTQTfnFM/bmoEZr8GHKr704o9IXzn1qy
         W3D5TKoBKdAEdjho5Fcuqvf7zNmJH+Rd/Sy/gi1UaXa/k1rWDOBn2Ul0Vbwg1jRFbkGw
         rKbTPeUQYbwDTUX/f/Xyv3prDoj232+eYb6Kjkw11HsvN7ntNHg7WBB201/nTnxT3Gln
         DXckL+ND6BWAI4tZW4mjydisKZLvetTgSgPaRqrUgYusQnVyMdD21yb0/bA71zsuf5lu
         4Iwsgo+HOZsOwr0uQ4GfOSlw+xvThSJxgneCCMgGEgIHXkoCN3xmZrfsqxV3mwWzBWe5
         7Z+w==
X-Gm-Message-State: AOAM530F0bI72VcVYVECqiPoyJBCTf4kux9y/3+j6rhaLR4p4EhY9S9n
        zGIoQzhHunsn/AmpdlhpROw=
X-Google-Smtp-Source: ABdhPJy6p13keJceAMdnUoLDhHTRRng2Q2rHUDL4w/x+gNWwvfHcBYTG0g+xir9/wkFK6uXlPiJ4/A==
X-Received: by 2002:a05:600c:2652:: with SMTP id 18mr2645873wmy.96.1613911571637;
        Sun, 21 Feb 2021 04:46:11 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id x23sm3035129wmj.32.2021.02.21.04.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 04:46:11 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sun, 21 Feb 2021 13:46:10 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Trent Piepho <tpiepho@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Please apply commit 517b693351a2 ("Bluetooth: btusb: Always fallback
 to alt 1 for WBS") to back to v5.10.y
Message-ID: <YDJWEh5qNUQbXcv2@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

517b693351a2 ("Bluetooth: btusb: Always fallback to alt 1 for WBS")
was applied to mainline fixing (restoring) behaviour to pre 5.7. As
the commit message describes in effect, WBS was broken for all USB-BT
adapters that do not support alt 6.

Can you consider it to apply it to back to 5.10.y?

Regards,
Salvatore
