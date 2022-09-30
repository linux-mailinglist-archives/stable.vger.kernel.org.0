Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E694F5F0C06
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 14:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiI3Muq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 08:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiI3MuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 08:50:16 -0400
Received: from premium237-5.web-hosting.com (premium237-5.web-hosting.com [66.29.146.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662C34DB34
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 05:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sladewatkins.net; s=default; h=To:References:Message-Id:
        Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Subject:Mime-Version:
        Content-Type:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=12NXnr2z1keDAzWsSMJB+NQHELqa6sTnkvzSKSwU7lo=; b=wT15qqRFvRFddoyhTY1wRTLpKN
        oeAUeQdWKE3HiscUcompuJImdQ/HMmRzL2G8B+V7a7g/KjQ1UM/0TDrEhQpuENSOm0H38RjB9l3is
        Enq0wa5BJ+agX2jId6d0acHePgnUfnIS0LltJkgt1x8FNIczAOJlMtd/yrxI7geCE5qBPMzBkzq1B
        qFSKMBiHKcER9ys5NlUIPnBTl8bZVXtH0O3VG8mw98PgCKF/QoWcQZtCZH41RAKFzR71Pb5IBvUud
        oodN/BCOSLDg6nsVydUdcLXlxwdaddBDluBFVRoMI6LJfYQ93Vxz0yLk6hxUvR0ehM/vnngKEBbhH
        voH9DPAA==;
Received: from pool-108-4-135-94.albyny.fios.verizon.net ([108.4.135.94]:55666 helo=smtpclient.apple)
        by premium237.web-hosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <srw@sladewatkins.net>)
        id 1oeFSp-0049fI-UF;
        Fri, 30 Sep 2022 08:50:00 -0400
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <aa8b9724-50c6-ae2e-062d-3791144ac97e@cern.ch>
Date:   Fri, 30 Sep 2022 08:49:41 -0400
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, regressions@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <3A2E2B7D-801C-461E-84DB-FFFB08DC7241@sladewatkins.net>
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
 <YzZynE2FAMNQKm2E@kroah.com> <YzaFq7fzw5TbrJyv@kroah.com>
 <03147889-B21C-449B-B110-7E504C8B0EF4@sladewatkins.net>
 <aa8b9724-50c6-ae2e-062d-3791144ac97e@cern.ch>
To:     Jerry Ling <jiling@cern.ch>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - premium237.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sladewatkins.net
X-Get-Message-Sender-Via: premium237.web-hosting.com: authenticated_id: srw@sladewatkins.net
X-Authenticated-Sender: premium237.web-hosting.com: srw@sladewatkins.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-From-Rewrite: unmodified, already matched
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Sep 30, 2022, at 8:26 AM, Jerry Ling <jiling@cern.ch> wrote:
>=20
> Hi,
>=20
> looks like someone has done it: =
https://bbs.archlinux.org/viewtopic.php?pid=3D2059823#p2059823
>=20
> and the bisect points to:
>=20
> |# first bad commit: [fc6aff984b1c63d6b9e54f5eff9cc5ac5840bc8c] =
drm/i915/bios: Split VBT data into per-panel vs. global parts Best, =
Jerry |

I just got Thorsten=E2=80=99s email about this [1]. Alright then.

[1] =
https://lore.kernel.org/all/b85bc2cf-5ea5-c5fb-465c-cd6637f6d30f@leemhuis.=
info/

-srw

