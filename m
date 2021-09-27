Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73937419758
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 17:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhI0PLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 11:11:06 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:20201 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235002AbhI0PLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 11:11:05 -0400
Date:   Mon, 27 Sep 2021 15:09:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail; t=1632755361;
        bh=fXzawrdPhcEiRRS7QLhl1QHyY5X/UCeVEnskCKUH7bU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=N3q8nlM1tBnSCynyg5Uipm+hGannC+rmUqXsWgyYW6EdS5xByFDPiY/BkJd7noAW3
         MfQ/X46GcWe4lWMMX7OOMxA92SxXM10jeXgKIepZSKCNoQ9MvU8HCSIRXnwyg8v3ss
         G18wCz2ELqZKr9sEk14h2vdhSVE/bv1CpdqtMqeXRSF9vf7ETKbzXDnNSLMz4ouVKR
         M5N6eIM88+D+CgsgdDVPGL5jS7CXUzrm92+UjfqjMSksfMYq4Iv7o49MgA0gPFPvAQ
         uhpyGwXovoiryR3oixdkWBkYQG39SHXZIl0U5NSOrnN+l82t7YAkuj9Kkud38cB1wR
         i2wfYUmEZLHhQ==
To:     Alex Deucher <alexdeucher@gmail.com>
From:   Simon Ser <contact@emersion.fr>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "for 3.8" <stable@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        =?utf-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reply-To: Simon Ser <contact@emersion.fr>
Subject: Re: [PATCH] amdgpu: check tiling flags when creating FB on GFX8-
Message-ID: <KvsBEjUfaluHmhGTchZazzOZHeVQEtdicj_znZpVB1gdwU3qaZr1bObQPplEh_EVcG2I_xsIUNuIEgFXCQ81VaLaiIgtKhfXE1q2NP718xs=@emersion.fr>
In-Reply-To: <CADnq5_PFMLUfadfA83bH7i4wAQdEtLWsKf7L7iLT_YjEhXDGug@mail.gmail.com>
References: <20210920103133.3573-1-contact@emersion.fr> <Kmwa-gfuqYfkMsvvUXAaujfROLLXX4PuTRBRQ5efixoEvM3arNB_yT5eure3D1iqmnFB54wnbB87S1zBLL-79Ci7fhqoKx-M-ciPVs5fcSU=@emersion.fr> <CADnq5_PFMLUfadfA83bH7i4wAQdEtLWsKf7L7iLT_YjEhXDGug@mail.gmail.com>
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

On Monday, September 27th, 2021 at 16:57, Alex Deucher <alexdeucher@gmail.c=
om> wrote:

> No objections from me with the WARN_ONCE change suggested by Michel.

Cool, just sent v2 with Michel's comment fixed.
