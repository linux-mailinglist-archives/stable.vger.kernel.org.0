Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DB365D6BA
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbjADPAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbjADPAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:00:14 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2357937398
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:00:12 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id 186so36774560ybe.8
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 07:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2d5jZY/cteIRWt4WzPFjkLtgXiH1fUpEhmjDmcQUQw=;
        b=QOSLxEyqI9MJQntfm+5nWG9BNRyLgtQsI4zBvXa3fov/C6eYfAEuhOaW8+gSKcvYFi
         /eV+V1Bp0khyrjezgzRtG664XF9DvLOYXJykPsXsabt7ENH3m2/qY2FTYpukO8ExJ1Dr
         zDHT35QxqMrm3z0Q3TSchi28JMCx2XlUIVyZ/zsq8Jy4lXmg5ID9V+Z+aSPzzOnCG/ux
         VZuQvaJ+l9Btyb/94UWls0FZ+6R/Og2nAcdiQ2VQ646UlEUY3kiCLjejVC6XPZxXOE4+
         2av9FlzbWEGJO+gJToZIbLrg7NehYa7CqiWOOvZODkAx8U5nB5Mu8yhfjNwYEuAuxR6Z
         +MYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/2d5jZY/cteIRWt4WzPFjkLtgXiH1fUpEhmjDmcQUQw=;
        b=iasSpCCLjdPKvvg6Zy07QhVz83CfUfTGgBMTcNj7wWRdyhnYCuqP6dOfsBtZ+SR7bd
         5OjtPpUTD+CpmR6ZXQDt91xfVXkZDQGBU28jfP1P4sMs28WK92z1Z8TkWfkF99qjQB+d
         b0QMcc6C9G3cl7jtIApbDc7lmKEjJu8iYX2LhoZ8+aM4L2qIrUbvwLe+dznOC1OHYk0M
         PSH7V4QOZ17X2BWJoiJjrUpmr/XrZdEodEzfWaetPJ4OCq4+QKxOkSgDaOkwsvSDeTIC
         blUxOxr1c9zsC2ok7o5VNH5SMh2gJVh8vuzWZYCKR2Zse9lZ2km5F5lpyjsjd8M4H/cD
         YU7A==
X-Gm-Message-State: AFqh2koxghMedu6xkV5YGV8TZuM5d8NwjYpMEddAQehRQItWKap7VAFD
        eClaEDtioI21b/tqR5I3GGgrSxsVExB7mx5HY04=
X-Google-Smtp-Source: AMrXdXsLUI6TUWg77oDGyUR1KuMBMEEft3cLU1yLEd4j1Men/Lej8odM/XZhXrpdvyXhZNLLFAv7J6o9Dn+5Bylusn0=
X-Received: by 2002:a5b:2ce:0:b0:7af:6c4d:4c2e with SMTP id
 h14-20020a5b02ce000000b007af6c4d4c2emr492462ybp.332.1672844411355; Wed, 04
 Jan 2023 07:00:11 -0800 (PST)
MIME-Version: 1.0
References: <1672843062134100@kroah.com>
In-Reply-To: <1672843062134100@kroah.com>
From:   Joaquin Aramendia <samsagax@gmail.com>
Date:   Wed, 4 Jan 2023 12:00:00 -0300
Message-ID: <CABgtM3hGjH-t-Vg7XHG3KrX6kzcXh9BYyPOJnJGCrp8nnAWMpw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] drm/amd/display: Revert logic for plane
 modifiers" failed to apply to 6.1-stable tree
To:     gregkh@linuxfoundation.org
Cc:     alexander.deucher@amd.com, bas@basnieuwenhuizen.nl,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Not sure why I'm getting this one, but this patch is already applied
to mainline in the 6.1 cycle. And is in stable from v6.0.12 IIRC.

Cheers
--=20
Joaqu=C3=ADn I. Aramend=C3=ADa
