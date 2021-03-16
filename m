Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E29533D3EC
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 13:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhCPMe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 08:34:58 -0400
Received: from mout.gmx.net ([212.227.17.21]:55419 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231877AbhCPMee (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 08:34:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1615898072;
        bh=nVTINIfa5TfDhuBIgFGy0SW1hkVyLt0qor3lmy10IAc=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=e4ZHnTImAW9zy3LXB8uHea9GERpRSLTwsA8vXwDfYPqGVh9v3M0zAqt1G7uT+fsru
         rkIG+2vUolz/SdwnNj15Hj7mpdqvckHGPV1g8YzE4V8FuOTxTfd5E2iwgHNqRe9sGB
         QBCCAGyS5OAPMqHsebLuJSbPIyBOwkh6VyuJnEoc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.1.35]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MeCpb-1lx7kd1RPL-00bHJm; Tue, 16
 Mar 2021 13:34:32 +0100
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.11 000/306] 5.11.7-rc1 review
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-ID: <ca67d634-3845-ef3b-1ffc-48471045f3b5@gmx.de>
Date:   Tue, 16 Mar 2021 13:34:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ODdEEw1uhBOLmUGNybUMkdDoAFiKWPWRLGVIvkF0/ciqCGark6F
 Njk0EB+8vUFHG4Yj5F+bcDw1pYwlNhhTWIPwaTsrAh9cGhQuoUb52oDdT/4XXl1hmNXcZOn
 7OkSoW9ya1PKDY3QavKQSTq7oGbNnBT+4IAqDHUbQYnfwog9W0KCHApQzky2P5vig6+/Ee0
 mMccnheOd1D9UBBvGeLfg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:q5wZxM0ou6w=:qExzfaP48LUdTqXkdXp/H8
 QdvDU125L2zJeE+2BmuxmFYrV9hkQ+LcBvgrtns1QbQhI+qgNXFjrr5L2bvLuXyKqxMM+QR0W
 DmAwX0kAPycY5Opasc88CEexFyw0YBMAe7RmSpelds07waUgCdwG9qkxAwXmH5lsM1W26RwFH
 kku65V5lVvN1TUTeZgdRk05XO+e6cqumbT5tIeXp7RsEA634I7j3Cjox5mIqUSajWXTFFbSjA
 n80Mk4ffSkWXK4cZnf7ayjKFvJKOHHtueQxLasHT119iGena/PpNHkttDIgou8pJVAVztFi3O
 0OLWL0dO+kInqxdBXmAQYPq82Es2ybLXImQmhgqwc+FvbHwlK7V82HfQ37etr+VZrrddJQsEU
 EfGHCu/YhQ2Gpa3aKQZUkaspoY25zm4gG3j+Vf6nT/Jy71m/bJxwl3EBThEa/b4Q7xAZLY/eh
 7wIhv5JadVsI3qYHm38zrHZoZlxvqhp1/DpipXHJtXHBnQOrH2BIfhEKwFnO3wx4V0LkpsJNp
 UWtXJ+J0sDFRh4VpinBiMes5lxPKDA44UKgSLpLi/694hJdNMYcLHPuMXwEBXT+FcHMXZNOn8
 VcrJ776wHAhESZTPkE6ZvJY8+bUAujFLeOI/tuPDgP7bOA/WCmFw7h72vE0WsecPQenfLYjwp
 2F6OarZmsadgEHRULm9jk2IQ+TrW0V63mVDk6GUPk2MMSQNsTawkELzTIvzmp2cesTrIvhwf1
 7tpwkMDel828JbihGucAfIjJkT0inn2PO63LdSXfKWP9XLo8bhDeM1Cyqx4KdUF9ng6jofrkf
 Lk69zmxZZq8+GRJsAPKfWy1V7DJst/dDBNb6naIBkzI4K7qmeQeW82BHPEBgqm5vHFIaTLsUC
 5vDClrxZvDsgoI3daWlQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hallo

5.11.7-rc1 compiles, boots and works fine here (Intel i7-6700)

alas a fix doesn't made it in (correct english ?), but AFAIK it's known
and queued in drm-next or so

bug/error (since 5.11.1 or 2):

i915 0000:00:02.0: [drm] *ERROR* mismatch in DDB state pipe A plane 1
(expected (0,0), found (0,446))


anyway, thanks
=2D-
regards

Ronald
