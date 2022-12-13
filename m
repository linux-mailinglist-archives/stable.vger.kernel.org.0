Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A501864B0C0
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 09:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbiLMIGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 03:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbiLMIGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 03:06:14 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D2865BA
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 00:06:13 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-14449b7814bso11626719fac.3
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 00:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=WgR45vwgHkQyopgjbmpgpxj5iBPUZfVes2/2C7pM0y7ep1ERE2L0JBkkywJQL7LOYG
         u7x4WhcPWhAYE4Mr2srMtJKE/94fVzAP59VSzLaK7KlukD6X7udwGnFYiS++wxdf2Zs0
         ZNNWH1w/ZFKqDYXgjArhDjNdl4R1ZUJ0k+uzBZE4Qfxbkpx1slZHBHbJCPr3MoSGEgom
         DCTqoqJyr5dSIiyl3a6YU635nown5Qved+94wNV0pPZ/BLmk4z/MNbPLXrDKmUGYIE+Y
         dRZuzHn1bg1HAp2URo19duL8wXywatslcHPnEAj29MpV2RiK5V2/b829y7+vSv6QjBBn
         oing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=jWckeXro8g8nN/AHZjJ8Y1dh+X6DlAm5G6YaHOeIRFUA9NULXnmwnDeXmOf+RrzO0u
         mGud8cZtq1/39mnOTm/6QPqkI6WcQxF6P3PyEfQmsCVnPl028BXuvDmwpqpm+OH+6s6A
         pyio8VMgLgI9PnMREou9+vnoaHWw61sKRlZnxwKcABzkuRO7KpPJSTfo70aVSZIcWUBc
         PT8Ez1aUJMnJclMFQ1eYCGUJF+BXqbFduNgUQqarFZSrgYraJ2JuXtnoTwvjUotYviPv
         hTgT8RYCm3OBKVemH6cL8ztBddtd1otlA3LgQD5Q5NAJ0AgYji9ydOGtrV5cCbYCY3Gv
         j5KA==
X-Gm-Message-State: ANoB5pkBOOE/wjKnwk3BezAEr0TBQa+UoEL3Yuv4F1gZ1AIOizW+0pCx
        0x8VIJsIa8b0dtU6hSyr3x88uVf+HHgv1zIQSqBBNJ3DyO4=
X-Google-Smtp-Source: AA0mqf7SWByFHrj34c988qfy6k1D0ddsrk9CPeA8FV9JJggGkR6shdaJYNQCufBTdxNaHriGCcnfk0Ub/LroD9Hy2pM=
X-Received: by 2002:a05:6870:355:b0:148:47ab:6a40 with SMTP id
 n21-20020a056870035500b0014847ab6a40mr160094oaf.5.1670918772706; Tue, 13 Dec
 2022 00:06:12 -0800 (PST)
MIME-Version: 1.0
References: <20221212130934.337225088@linuxfoundation.org>
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Tue, 13 Dec 2022 13:36:01 +0530
Message-ID: <CAHokDBkjb+AKQrmf_zgGtSZvx-q0eN2XE9FVYbEV733B4PFe=w@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>
