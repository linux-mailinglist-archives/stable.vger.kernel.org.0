Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F664194D1
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 15:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhI0NKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 09:10:55 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:26633 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbhI0NKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 09:10:54 -0400
Date:   Mon, 27 Sep 2021 13:09:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail; t=1632748151;
        bh=BnSfJtEaCcmkJzZxduXBRRB3iYQknJfIOtJ9Knwc3Cc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=b9kTQ/dxtXSZ79P9LMuyk0er0loPVE9lfuolCSzLF3hPSriKWoAyib/AyiaLdwrEr
         NsnYxob0XAk2/gwTH2oosr9T/8r7odShlvALlVuEN74gykcTUOaNmkp8pL6jFBsusw
         BR7aH6T4KIxzYKWK2Zttoa1gFsIM8N7t+sge383DqohumCqv/mgrr1Cey3Nga7MNZB
         +j+r+aw8hxridYetWrqpqcyUYaa97xUdjwGsRnoiQrAMcIl7GqJAEkAK4m+Ec4fgRo
         a/XDrDgNGqJdlh7ltkIUoz0N/OP3CCz/Ap63Oz7J9nOcDOEROU7jxZq1GkVx13MYw6
         WVHbF+h+ctn4w==
To:     amd-gfx@lists.freedesktop.org
From:   Simon Ser <contact@emersion.fr>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        =?utf-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reply-To: Simon Ser <contact@emersion.fr>
Subject: Re: [PATCH] amdgpu: check tiling flags when creating FB on GFX8-
Message-ID: <Kmwa-gfuqYfkMsvvUXAaujfROLLXX4PuTRBRQ5efixoEvM3arNB_yT5eure3D1iqmnFB54wnbB87S1zBLL-79Ci7fhqoKx-M-ciPVs5fcSU=@emersion.fr>
In-Reply-To: <20210920103133.3573-1-contact@emersion.fr>
References: <20210920103133.3573-1-contact@emersion.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alex, Harry, Nicholas: any thoughts on this patch?
