Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66073C6BAB
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 09:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbhGMHtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 03:49:01 -0400
Received: from mx6.ucr.edu ([138.23.62.71]:17118 "EHLO mx6.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234342AbhGMHtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 03:49:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1626162372; x=1657698372;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:to:cc;
  bh=/PDBt9wlRWM1iCLp+k/CLplY3xQTV5OM8VyXbBUUaog=;
  b=AgJvR9YPOYo55oU70TRbahZTMKg6od1iLRg1jd/q48MB0yRH647MZzGo
   J0kj0Itca9NCmteud7SkvM1D4IT24kdwANMioLhFdIcLFwMZp0Qk81k3U
   dApJ92iDZQyQ0dHxDteJs4GxJGap15IX4vMRMHGIa9O7+I6syVgXkFhHe
   D9UZ20fk33PGPNj8w3Hs1L3juNk5b7GpsuMdORnCky/hL8wqCWxii+Zna
   7W7VUk/wPIA3rbF5sTyzNMEdF9Zo02seGtb/0gWCaZkbHG+1ct1fhDu/C
   3Fna1tWb3W4YyVTzLvSq9/6kwyHZk/ptnN8+lA1KF14Gqcwn3Yf33u9TP
   A==;
IronPort-SDR: Vwpdex8LoMTSiW+tEVVc/VucFrCViI1PpEPm0dFTpGefimJu1qzkf7/dywUOfAiEz81kDifjIc
 X0kP9PSF9yc+REW71vczV6fCUK/61vF1PsP7hY6VkqjvZpK1HOz9a5VSDmIR5+POccA15VnqUo
 lFDKEBQPxq+lOo7rhBArBkYlhLYjq/TZ39gNfYndnfJzxFEh7GQQX6NQfnj4nfOs9lLkeVOLmh
 IrORPNd8d0oG86USJKHs8oR48xyLFhAKST9pQI09s9AyT66HRcbZ0cG8TcmOVQCBSraeNGpNwn
 MHk=
X-IPAS-Result: =?us-ascii?q?A2HjAgCfQ+1gdEihVdFaHgEBCxIMQIFOC4MiVmwCGIQuk?=
 =?us-ascii?q?VsDlhuCa4JUgXwCCQEBAQ83CgQBAQMBA4ESgndEAm2CDAIlNAkOAgQBAQEBA?=
 =?us-ascii?q?wIDAQEBAQUBAQYBAQEBAQEFBAEBAhABb4UvOQ2COCkBUhIDDVYBAQEBAQEBA?=
 =?us-ascii?q?QEBAQEBAQEBIAIBAQEmAggFTQVnAQEBAxIRBFIOAgsLDQICJgICGwcSAQUBH?=
 =?us-ascii?q?AYTCBqCUIMHBQqbOYEEPYsyfzOBAYghAQkNgV0GBQ1+KocJhmIngimBS4EFg?=
 =?us-ascii?q?Wo+gmIEhHWCZASDGUxVGHtSbUBTAQEBnwqadoIPAQYCgwocijKUAiuDY4tch?=
 =?us-ascii?q?j2QWC2UR41AkxcLhUkQI4E4ghUzGiV/BmeBS1AZDod/hiwWg04zikskLwIBD?=
 =?us-ascii?q?CkCBgoBAQMJh2cBAQ?=
IronPort-PHdr: A9a23:jXi7whJrMJFW/JVpvNmcuMBmWUAX0o4c3iYr45Yqw4hDbr6kt8y7e
 hCFvbM00BSXA82bs6sC17OH9fi4GCQp2tWoiDg6aptCVhsI2409vjcLJ4q7M3D9N+PgdCcgH
 c5PBxdP9nC/NlVJSo6lPwWB6nK94iQPFRrhKAF7Ovr6GpLIj8Swyuu+54Dfbx9HiTajfb9+N
 gi6oAreusQXgIZpN6I9xgfUrndSdOla2GdlKUiPkxrg48u74YJu/TlXt/897cBLTL/0f74/T
 bxWDTQmN3466cj2vhTdTgWB+2URXHwOnhVHHwbK4hf6XozssiThrepyxDOaPcztQr8qXzmp8
 rpmRwXpiCcDMD457X3Xh8lth69VvB6tuxpyyJPPbYqLKPRxYL/SfdICRWpAQMlRUTBBApihZ
 IcLFuYNIPpUo5X4q1YIsBCwBxSjBPn3xzBHiH/536003eoiHw/bwgIvA8kDsGjIoNjvKKseT
 fy5wavOwD7eb/1WwzD96I3Qfx8goPGDR7VwftbRyUYxEQPOk1afqYv4PziI0ekMvGma7+19V
 e6zlmIqqRp8oiWzycc2kIXGmJ8ayk3d+Ch/3Y06KsG2RlRhbt64DJtfqTuaN41uT84sTW9lp
 Tg2xqAFtJKnYiUHypUqyRHfZfGac4WF4gzuWeSfLzp8in9oZb2xihSy/0WhxOPyVsq53EpIo
 ydbnNTBsG0G2RLU6siCUPR9/0Gh1C6U2ADU7eFEPUQ0lavdK5I73rEwkZ8TvVzbHiDonkX2g
 7KWdlk++uiv7eTnY7rnqoWBOIBqjAz1L6cgmtSnDOgmLgQDW3KX9Oe82bH54EH0QahGguc0n
 6XHtp3RON4VqbSjAwBP14Yu8xO/DzC739sGhXQHN1dFeA6fj4juJlHOPOj0DfehjFSolzdm3
 /XGMafgApXJN3TDl7Dhcatk505Sygc/08pT551TCrEGL/LzXlH+uMbEAR8+Ngy42+fnCNNj2
 YMCQW+DHLOVPafIvVKL5u8jOfSAaY4ItDrnKfUp+ebijXojll8ceamp04EXaHe9Hvl+LESYY
 H3sgsodHWsXvAczV/Hqh0GYUTJJeXm9Qr886ikhCI26FYfDWpytgLuZ0SegAp1ZfHtJClSSH
 nrzaYWEVOkDaDiILs9ijDMET76hRJEl1R20sw/60bVnfaLo/Xg9vIjonPtx6uzVmFQY6DB4A
 ozJ1mKJZ3l5mGwVWyUx2qFv50BwnASty6991sxZHNtY5/5PGjU9KNaI3/59FoirBSrcdc3PR
 Vq7FIb1SQotR848loddK312HM+v21Wah3LCPg==
IronPort-HdrOrdr: A9a23:pEI39qhh8EEx1P50mDi/rVKTMXBQXuEji2hC6mlwRA09TyVXrb
 HWoB17726NtN9/YgBEpTntAtjjfZqYz+8X3WBzB9aftWvdyQ+VxehZhOOI/9SjIU3DH4VmpM
 BdmsZFebvN5JtB4PoSIjPTLz/t+ra6GWmT6Ynj80s=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="228066433"
Received: from mail-oo1-f72.google.com ([209.85.161.72])
  by smtpmx6.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2021 00:46:11 -0700
Received: by mail-oo1-f72.google.com with SMTP id e10-20020a4ab14a0000b029020e1573bdb7so9245567ooo.9
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 00:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E0c/itnJRqvseiRzZWaYFdOYbaZVWfzwqyJIgaHRkI4=;
        b=g2g7IuLuhbE4IjuWC5E27TzmxR4FoBxQBrNHvcUyWvFJQrQWsZDtE1DTOostuLD46v
         KEf8ZpaINZ0efSx6+a0eN5kM/A29LpiOLdXcuSIPiLpHP1hdXiixbicfbHB/XdSIZt10
         C8DmE1N8H59RqyxArBFMbxXT4maA6AeuRwMyM/pcRqHCuC9TAKp0GhxfJH26nwnC+gKi
         qCZ54NnN6LOV9HEKMZB8oF4H2wz8UA7ABaHMSDZTDK6T/hQ1lgJQNAqjIyEq4rh86Zct
         4Qw4WQeWZFe5jzgdkJQPgPEV0135m5kIPMPQKlWY1518Gk90+TcfskvEZ5Ud9UBTVh3g
         MueQ==
X-Gm-Message-State: AOAM532i3KzcGzPsXTkVgioJG7cSk+mVlOET412rUR7PSiyWznjytSKm
        l9765WqWRRaXt7TcYpXolexK4bT0vPL1vSbgc/CTFP/CsF9xOQ7Sl9N/3WA8q23xfpV68xp9RbW
        CX7UahMLsHBjl0lrGDA9MHF64FJBvymuTyA==
X-Received: by 2002:a05:6830:1e42:: with SMTP id e2mr2537579otj.135.1626162369807;
        Tue, 13 Jul 2021 00:46:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBf6asctnycGHrf0aHsUd7mMNxKyN11KyP8TucFVKHbFU6gvW9YJZO6cqXJ6+ucEspUXAJ06v7fWy8ISSDRwE=
X-Received: by 2002:a05:6830:1e42:: with SMTP id e2mr2537573otj.135.1626162369633;
 Tue, 13 Jul 2021 00:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAE1SXrtrg4CrWg_rZLUHqWWFHkGnK5Ez0PExJq8-A9d5NjE_-w@mail.gmail.com>
 <YO0Z7s8p7CoetxdW@kroah.com> <CAE1SXrv2Et9icDf2NesjWmrwbjXL8067Y=D3RnwqpEeZT4OgTg@mail.gmail.com>
 <e1f71c33-a5dd-82b1-2dce-be4f052d6aa6@pengutronix.de>
In-Reply-To: <e1f71c33-a5dd-82b1-2dce-be4f052d6aa6@pengutronix.de>
From:   Xiaochen Zou <xzou017@ucr.edu>
Date:   Tue, 13 Jul 2021 00:46:07 -0700
Message-ID: <CAE1SXrv3Ouwt4Y9NEWGi0WO701w1YP1ruMSxraZr4PZTGsUZgg@mail.gmail.com>
Subject: Re: Use-after-free access in j1939_session_deactivate
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

j1939_session_destroy() will free both session and session->priv. It
leads to multiple use-after-free read and write in
j1939_session_deactivate() when session was freed in
j1939_session_deactivate_locked(). The free chain is
j1939_session_deactivate_locked()->j1939_session_put()->__j1939_session_release()->j1939_session_destroy().
To fix this bug, I moved j1939_session_put() behind
j1939_session_deactivate_locked() and guarded it with a check of
active since the session would be freed only if active is true.

Signed-off-by: Xiaochen Zou <xzou017@ucr.edu>

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index e5f1a56994c6..b6448f29a4bd 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1018,7 +1018,6 @@ static bool
j1939_session_deactivate_locked(struct j1939_session *session)

        list_del_init(&session->active_session_list_entry);
        session->state = J1939_SESSION_DONE;
-       j1939_session_put(session);
    }

    return active;
@@ -1031,6 +1030,9 @@ static bool j1939_session_deactivate(struct
j1939_session *session)
    j1939_session_list_lock(session->priv);
    active = j1939_session_deactivate_locked(session);
    j1939_session_list_unlock(session->priv);
+   if (active) {
+       j1939_session_put(session);
+   }

    return active;
 }
@@ -2021,6 +2023,7 @@ void j1939_simple_recv(struct j1939_priv *priv,
struct sk_buff *skb)
 int j1939_cancel_active_session(struct j1939_priv *priv, struct sock *sk)
 {
    struct j1939_session *session, *saved;
+   bool active;

    netdev_dbg(priv->ndev, "%s, sk: %p\n", __func__, sk);
    j1939_session_list_lock(priv);
@@ -2030,7 +2033,10 @@ int j1939_cancel_active_session(struct
j1939_priv *priv, struct sock *sk)
        if (!sk || sk == session->sk) {
            j1939_session_timers_cancel(session);
            session->err = ESHUTDOWN;
-           j1939_session_deactivate_locked(session);
+           active = j1939_session_deactivate_locked(session);
+           if (active) {
+               j1939_session_put(session);
+           }
        }
    }
    j1939_session_list_unlock(priv);

On Tue, Jul 13, 2021 at 12:35 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 7/13/21 9:30 AM, Xiaochen Zou wrote:
> > j1939_session_destroy() will free both session and session->priv. It
> > leads to multiple use-after-free read and write in
> > j1939_session_deactivate() when session was freed in
> > j1939_session_deactivate_locked(). The free chain is
> > j1939_session_deactivate_locked()->
> > j1939_session_put()->__j1939_session_release()->j1939_session_destroy().
> > To fix this bug, I moved j1939_session_put() behind
> > j1939_session_deactivate_locked() and guarded it with a check of
> > active since the session would be freed only if active is true.
>
> Please include your Signed-off-by.
> See
> https://elixir.bootlin.com/linux/v5.12/source/Documentation/process/submitting-patches.rst#L356
>
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
>


-- 
Xiaochen Zou
PhD Student
Department of Computer Science & Engineering
University of California, Riverside
