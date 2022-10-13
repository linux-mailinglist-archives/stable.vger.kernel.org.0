Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202685FE2B4
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiJMTbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiJMTb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:31:29 -0400
Received: from mail-4022.proton.ch (mail-4022.proton.ch [185.70.40.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0F8180250
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 12:31:27 -0700 (PDT)
Date:   Thu, 13 Oct 2022 19:31:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail3; t=1665689484; x=1665948684;
        bh=Ca3A6azgYVUhqCTGWggmJR2+U0rpOhVXgfCycSVKqag=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=avpcAhtW3xAD4nYP6xDuEDaxL+oahrve8KtPr9j+PoCqPDvu3gDJvoYuBPwo3izzX
         g9ybPZ5q5facEo4ZW5nczLnG14mKJwU/SMRggn0em2LCGeWtz4fUSJdZGcqHCgIpZw
         lX/5Q2V2EN9gFeesCrOH2EqenFzyth5rGbQWmOqYlmk15/xpC/rOajbOLMuLq5mxUd
         bsIxF0vhTX8Oq1rpg8jFC4c5Y4+Xo977Zt/gOGV3DVAfHEv6P0YgRm8+DCsvczZ/6/
         h7MYRKp5tb0m/HoS/eaVbikWrIXfvWqSScRyyNXev7/7zzCnrH4ZLUdqD8wTSAeh+g
         YycZkopvL/1kQ==
To:     Sasha Levin <sashal@kernel.org>
From:   Simon Ser <contact@emersion.fr>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?utf-8?Q?Ville_Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Lyude Paul <lyude@redhat.com>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org,
        =?utf-8?Q?Jonas_=C3=85dahl?= <jadahl@redhat.com>
Subject: Re: [PATCH AUTOSEL 6.0 16/44] drm: hide unregistered connectors from GETCONNECTOR IOCTL
Message-ID: <0-fHhpvbGPf-w86Z7MGNoAe5uxHJy7vAdHcgjqqC2x8UWTZ7YY6wYORyxtrzDIf2pyPLt7z6dfFGOeUozmm7o0Qz0hpmhevj38g3Np3H1jI=@emersion.fr>
In-Reply-To: <20221009234932.1230196-16-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org> <20221009234932.1230196-16-sashal@kernel.org>
Feedback-ID: 1358184:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jonas has reported that this breaks Mutter. Sasha, can we remove this
from the stable queue?
