Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06AD7235C1
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387547AbfETMhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:37:35 -0400
Received: from mail-it1-f182.google.com ([209.85.166.182]:51898 "EHLO
        mail-it1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391247AbfETMgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 08:36:18 -0400
Received: by mail-it1-f182.google.com with SMTP id m3so18807939itl.1
        for <stable@vger.kernel.org>; Mon, 20 May 2019 05:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Y1ffTQvFrLX9xttKcfxL6zk5PsLouKd0i7QSjMkEJtk=;
        b=AcHPki+93t7cPLv5xAOX0N1TnIy3EtQ8MNpwqAp/c5j63vaib5nSpLDIo3sO4465Rg
         OJgskfYf+cL8pLXraQmPXguctLosntgngZCYG6tAgjW95D4s3FK66QRxBnkEdbdL22pS
         Oih7mr6zKVUllWdRZKiVFJZU/iLNK4V+5QXipxiviIt2QmKpAkk0L5AfIQBgL6ravhGD
         2duw7BoYytryDGMH1wP12cd6H2jISSrVemwrfdTPEWyAnh7DJ3N87jb0IyVvyNsIzDiY
         eKDjp3FLVcBcU3a2CyWaTCVxD2tQgxbrY61tzsRbHWxo6taQK/mlVX8pYatgoBmFEwIA
         L3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Y1ffTQvFrLX9xttKcfxL6zk5PsLouKd0i7QSjMkEJtk=;
        b=KNH0qEGpIH3owuYqZrXB447gJojaBwX8tFFKi8kHcW9GuoplUexVKPD2cDoSBEwGhj
         xdO13Mp0xSdFyuOr2VpImXJlYjBPQh4uV/omFX9c+QPIDqHMSJZmB/4uIw/KzO6emVc5
         amR0pNos6fpO+iaS0NWXKF6AqOBg2ClMYujPMBkTcFBL8mJK9ZXnoQ5d+I3tV2P5+vlS
         I6cMr9qzr0ng86se4VjPL7YocJu1EDCTjLFNp0Lj9SknERIwz+xcEJg7GmPmT8PZf+zV
         l4BnCf5FyDf7zFMhAYar6J/DbKrYVKBicuY3neGJ9T/b1zyT5VGNehWBdyJva7G9jzDI
         cGuw==
X-Gm-Message-State: APjAAAVnJXrlVaWUPPmtL1Q9aWZJVjFEMpe2JBaSkjEwyViAxmcO3rE/
        WXA2vdHvi4V/Wp/+SEXzIYKFrc4NKEtCzygLZTzqFu7Y
X-Google-Smtp-Source: APXvYqzPY+ZaduNBncKIH1qSEE//s32ZVGTKS8XtkdyUaq2csdfWImoaP2RXPHNZtnIKLNjEn2SwEpvy8MiDMtp7awA=
X-Received: by 2002:a05:6638:350:: with SMTP id x16mr6009908jap.95.1558355776719;
 Mon, 20 May 2019 05:36:16 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 20 May 2019 07:36:05 -0500
Message-ID: <CAHCN7xL_F+8Ev4=Wf8QsH2WT84KWfOf4d=4wKboPg1EZ-6442Q@mail.gmail.com>
Subject: ARM: dts: imx6q-logicpd: Reduce inrush current on USBH1
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply 7aedca875074 ("ARM: dts: imx6q-logicpd: Reduce inrush
current on USBH1") to the 5.1 stable branch
