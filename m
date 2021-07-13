Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7973C6B50
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 09:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbhGMHkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 03:40:33 -0400
Received: from mx.ucr.edu ([138.23.62.67]:22091 "EHLO mx5.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233762AbhGMHkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 03:40:33 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jul 2021 03:40:33 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1626161865; x=1657697865;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:to:cc;
  bh=Uy3h8jSbfs/h+jDYaxXZtCw4dzE0irLxzHb3QVi8SvA=;
  b=krsMsSfEzYBtBMFtu5iQxjO+w70+8LU4/oW9GGfXRxCvAEHYRURrh1T3
   Fm1VFcWT6P5pESRNuTC6ByTpBAEEnizVqhIL69t566PvRpmr9w2cfmie1
   D72PCqiNf/7v3IFheOtsekr+ykFIO85clZPlSNGMSvzaudWmEI5gXObI5
   OagIt2oWBsI7Y/k9KKkRg4whzHyEuS61yrhL0+ZP0LZd9NeHQRDlQ9p9+
   wqV6kSKd2PJmp/FMJHkd+18qLWGOgUtAKtK861V9sCPOsVgcJUFnnmbwZ
   FYg+ANWrp3T0mO9v/YU2fCEqgfBev5epMrDjKLXMOExsGh8SQr8/gxULZ
   Q==;
IronPort-SDR: abed+du9dlPaXbYY8QoZBl2WxXw66FcR/fUP/ObUCRwqbQi+iCxqGYBGqDajqfHZwr4GttBQz/
 UOL0gu06kqK3WXZ9zDRbC7LwW7YE3ELXHP3Tka6/w24ieUAb1AM8SlDjv0kOlRFMySskbqJiFk
 CUPH6qBzTCxttyH5seLqJksA4eVsmjkSXQgl1zqd0JJDVRguvmVLv4ol/MYR2wC8/2J4McskAN
 BBWg0agKtdyUrG8/i1GdDG+safza8Xl72EMaVaCPXp4P9I9wZUq07HwQ3tnfNkTdsK6d/uM7Dw
 vE0=
X-IPAS-Result: =?us-ascii?q?A2GkAgAsQO1gdMWnVdFagQmBWYN4bIRIkVwDlhuFP4F8A?=
 =?us-ascii?q?gkBAQEPQQQBAYRUAoJ5AiU0CQ4CBAEBAQEDAgMBAQEBBQEBBgEBAQEBAQUEA?=
 =?us-ascii?q?QECEAFvhS9GgjgpAYNtAQEBAxIRBFIQCwsNAgImAgIiEgEFARwGEyKFVwWbT?=
 =?us-ascii?q?oEEPYsyfzOBAYghAQkNgWMSfiqHCYZiJ4IpgUuBBYFqPodbgmQEgxlMVThbg?=
 =?us-ascii?q?T9AUwEBAZ8KmnaCDwEGAoMKHJ40K4NjkhmQWC2UR6BihUkQI4E4ghUzGiV/B?=
 =?us-ascii?q?meBS1AZDod/hiwWjkwkLzgCBgoBAQMJh2cBAQ?=
IronPort-PHdr: A9a23:0Z/lHxCqLoUyMaMU6XeQUyQUd0MY04WdBeb1wqQuh78GSKm/5ZOqZ
 BWZua81ygaVFtuFo7Ic0qyK6vGmATRBqb+681k6OKRWUBEEjchE1ycBO+WiTXPBEfjxciYhF
 95DXlI2t1uyMExSBdqsLwaK+i764jEdAAjwOhRoLerpBIHSk9631+ev8JHPfglEnjWwba1uI
 BmssAncucYajIpjJ60szhfFvmZEd/5ZyG91IV+fhQrw6tu18JV+7ylepvUt+tJaX67nZao4V
 7tYDDonM2Ax+sLmsATIQBWM6HUBTGgYiwJEDAfZ4h70WJfxqTb6ufFm2CaGJ832TKs7Viqk4
 qx2VRLnkiYHNzo+8GHKlsx9ib9QrRy9qxBjxYPffZqYP+RicKzDYdwaRHJBXsdPWCxHHoO8d
 JYEA+4YMepFs4Xxu14CoB2jDgeuGezv0CdFiXD43aI40+ovHwLI0hE+Ed0Sq3nUsMn5Ob0OX
 eyp0KXFzzPOZO5W1zfn74jIdwgsrvCNXb1qdsre1UkvGB3Djl6NqoPlOC6V3fkKvmmU7utgU
 v+vh3I6pwxzuTWv29sjipPTio0L11/E6Dx0zYAoLtK3VEB1e8SrEIdMty6ELYt2RNsvTm52t
 SomxLALu522cSkExZooxxDSaf6Kf5SI7x/9V+ucICp1iXxldr+8iBu8/0atx+/iWsWozFtHr
 yRLnNnQun0Lyhfd6dCHR+Nj8ku93TuDzQPe5+FeLUwplKfWKYQtzqM0m5cRt0nIAzX4l1/sj
 KCMc0Up4u2o6+P6bbr4vpKcLIp0ih3mMqQph8y/Hfw0MggQUGif/uSxzLjj8lf4QLVOl/E2l
 ajZvI3DKcQVu6K0Bw1Y3pws6xa4CDem39AYkmcdIF1ZfxKHipDlO1DIIP/mEfeym0qgnCtvy
 vzcPbDsAo/BImXCnbrjZ7px9kpRxQgrwdBa/Z1UC7UBIPzpWk/2sdzVFhA4Mg2zw+b6FNlxy
 4ETVHmSAqCFKqPeq0GH6f8yI+WUfo8apC79K+Q55/7plXI5gkMdcrOy0psTdn+1BepmI0qHb
 nr2mNsBEnkFvhA4TOP0jF2OSzlTZ2y9X/F02jZuJ5irAs/gZsj5j6aM0w+4BJpfZiZNDVXaQ
 lnycIDRa/YFbymSL8kpoDsZHeyxWYg8jUjxnBLx0fxqIveCqX5Qjo7qyNUgv76brho17zEhS
 p3Fiwmw
IronPort-HdrOrdr: A9a23:HrmQe6jANB1YWvuFFX5Ju7RJS3BQXuEji2hC6mlwRA09TyVXrb
 HWoB17726NtN9/YgBEpTntAtjjfZqYz+8X3WBzB9aftWvdyQ+VxehZhOOI/9SjIU3DH4VmpM
 BdmsZFebvN5JtB4PoSIjPTLz/t+ra6GWmT6Ynj80s=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="225496942"
Received: from mail-oi1-f197.google.com ([209.85.167.197])
  by smtpmx5.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2021 00:30:38 -0700
Received: by mail-oi1-f197.google.com with SMTP id s11-20020a05680810cbb02901eef9e4a58cso10282468ois.3
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 00:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aDD2Q+fBWLzKLVqo6MihicdQ+2ekQXHH6v82dt1m7ug=;
        b=cMXOoFSDqsfcb6CdbKDqympwegZEr0s2BgICn4EfsGHiQJ30QtuE94oda3aEEGbapS
         RWh2r6J2PbgSbi+JK4g8AFFqFh7iTm1rLvUrUnIs0EphRgDX1wtJoZ6GTnS4h0Jp47zl
         ixS9qtPgQjmO8yvL0pjpETpDQi1X/eMRCHYOXOPd2A8/PVbKLp7+m9h5tSXXYjCdYNe/
         N3jw9SOgwqsY8erBwvTskLHRS694KjFXiv3pyiZcMOfno9szlX863AKZxSgl9ElozW95
         HVGVFCAyWK7kt1bcZ7qinoVNP9SXiSw1BCOML62QTBAvOnDWlIWlOsQJfiAzWW8DMj5q
         XYIg==
X-Gm-Message-State: AOAM532QnQAB6e1jDhpGEjbToowsMT531gBzefNmYaodxysBfeVLm+Bl
        cnAKGUc5nY2zX9NiMRYkEHtw01rR9ZdbhrnIbICvv5U5drD2jdIsHLs9B/X8/ou19r471FRFTRz
        9JnvGth45BH7GV8yRx2NdkGPi5b79StSEHw==
X-Received: by 2002:a05:6830:1604:: with SMTP id g4mr2357898otr.57.1626161436684;
        Tue, 13 Jul 2021 00:30:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwV3NlabbiVN4+hSJ2ftBWmY3gwiUebuedfsGMLB8buEyZLOA0TyY1lXUMhXESUXtUWj6GuSM/9a0TgGVowM5Y=
X-Received: by 2002:a05:6830:1604:: with SMTP id g4mr2357887otr.57.1626161436495;
 Tue, 13 Jul 2021 00:30:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAE1SXrtrg4CrWg_rZLUHqWWFHkGnK5Ez0PExJq8-A9d5NjE_-w@mail.gmail.com>
 <YO0Z7s8p7CoetxdW@kroah.com>
In-Reply-To: <YO0Z7s8p7CoetxdW@kroah.com>
From:   Xiaochen Zou <xzou017@ucr.edu>
Date:   Tue, 13 Jul 2021 00:30:34 -0700
Message-ID: <CAE1SXrv2Et9icDf2NesjWmrwbjXL8067Y=D3RnwqpEeZT4OgTg@mail.gmail.com>
Subject: Re: Use-after-free access in j1939_session_deactivate
To:     Greg KH <greg@kroah.com>
Cc:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

j1939_session_destroy() will free both session and session->priv. It
leads to multiple use-after-free read and write in
j1939_session_deactivate() when session was freed in
j1939_session_deactivate_locked(). The free chain is
j1939_session_deactivate_locked()->
j1939_session_put()->__j1939_session_release()->j1939_session_destroy().
To fix this bug, I moved j1939_session_put() behind
j1939_session_deactivate_locked() and guarded it with a check of
active since the session would be freed only if active is true.

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

On Mon, Jul 12, 2021 at 9:44 PM Greg KH <greg@kroah.com> wrote:
>
> On Mon, Jul 12, 2021 at 03:40:46PM -0700, Xiaochen Zou wrote:
> > Hi,
> > It looks like there are multiple use-after-free accesses in
> > j1939_session_deactivate()
> >
> > static bool j1939_session_deactivate(struct j1939_session *session)
> > {
> > bool active;
> >
> > j1939_session_list_lock(session->priv);
> > active = j1939_session_deactivate_locked(session); //session can be freed inside
> > j1939_session_list_unlock(session->priv); // It causes UAF read and write
> >
> > return active;
> > }
> >
> > session can be freed by
> > j1939_session_deactivate_locked->j1939_session_put->__j1939_session_release->j1939_session_destroy->kfree.
> > Therefore it makes the unlock function perform UAF access.
>
> Great, can you make up a patch to fix this issue so you can get credit
> for finding and solving it?
>
> thanks,
>
> greg k-h



-- 
Xiaochen Zou
PhD Student
Department of Computer Science & Engineering
University of California, Riverside
