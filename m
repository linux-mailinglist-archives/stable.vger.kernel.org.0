Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B289065D6BD
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjADPA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239556AbjADPAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:00:53 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8C5B2F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:00:51 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id 186so36777132ybe.8
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 07:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VnoiWjVIbV39l1Ct/C11VzTCk1KwuNX9qVQE8NV1ye8=;
        b=SMOJf1qQA3TK9xP7G5661L2JdRGE5yhffx6g7vPb7hWgN+2FgmUUat4LYCYC/49zwW
         H7wdih0PMnmY8BxlfRB9+VGaFOxftcttCd4RaZO+u9Z1zaz50bZS5J4hSC7Z3O2bO2xD
         whqCouXjPaTHYWfGQZypaXN4jVup1uCiAhD5Ebf9/ABZshv21y66vFCBmOtn76QWPps4
         jclAByfb1vveYaRDGWZP5VmWAQ1KeYR7heFWqWzQaOKRLnC1Uu/xI1QvvVwUlhbwjo/Q
         NnST8tDIy7+iMGvbY7qWi5x9Y2pcuq4oMWmCzeSgS5hdrQujlWwkTNgb7O86JmNUMLDa
         NLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VnoiWjVIbV39l1Ct/C11VzTCk1KwuNX9qVQE8NV1ye8=;
        b=7oDihMetM/WhhCMr3AL0Bkaob/9C8sRWVYgskqg0iJWaghJAoX/ap9wuINLGl/MbSy
         /5ZvVxhgk6CnKZbnxytrtAI5LJM0EDKQSItUnasQokbGyQi6b805W2pwSYoeBVzwwnC8
         vU1UQh4PTnPOOdakwmLi8AfKui2kE+nfh/E482t/WNURUXJVK65pCZf8phZazDpQVziG
         N8flJrtz+iOoN4FdB7q9zcWYxHS3Dp8gvrnJSMjvSJ75AfjvgAm/P0wiaf8dWjIoPLdW
         FUaQ3ktRGGF1FNwCFTcu6vO8MNsEwdzIOUIp7Gptl0mfZLltLsdramkBIUvO/NL638aJ
         v2zw==
X-Gm-Message-State: AFqh2kpvD1AJLDyyxa+GmNRdPk/B/eXyYXEuoDRR83nkz/ZQMz24xknG
        rlsknZx/RRIDvOhU41ssUBjJ5JklnZh2LHW9xs2M3/Gp9WE=
X-Google-Smtp-Source: AMrXdXvnL5x91U6Yk9hGvgio26GFtVeEeY/unAcCNW1XWGeRsKsxVQ+EEcJzFqg6cYT0GuNTGyv59IfPggD+UAsHVoA=
X-Received: by 2002:a25:d012:0:b0:705:fc5e:4313 with SMTP id
 h18-20020a25d012000000b00705fc5e4313mr4764955ybg.180.1672844450271; Wed, 04
 Jan 2023 07:00:50 -0800 (PST)
MIME-Version: 1.0
References: <167284306345198@kroah.com>
In-Reply-To: <167284306345198@kroah.com>
From:   Joaquin Aramendia <samsagax@gmail.com>
Date:   Wed, 4 Jan 2023 12:00:39 -0300
Message-ID: <CABgtM3j8XKQDi7yS6MJ7yZJ1HdsQ4opoD6v1NY0VXOMPhw4V_g@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] drm/amd/display: Revert logic for plane
 modifiers" failed to apply to 6.0-stable tree
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

El mi=C3=A9, 4 ene 2023 a la(s) 11:37, <gregkh@linuxfoundation.org> escribi=
=C3=B3:
>
>
> The patch below does not apply to the 6.0-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.


Not sure why I'm getting this one, but this patch is already applied
to mainline in the 6.1 cycle. And is in stable from v6.0.12 IIRC.

Cheers


--
Joaqu=C3=ADn I. Aramend=C3=ADa
