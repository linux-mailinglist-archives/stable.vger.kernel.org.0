Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F903CA54F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhGOSYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:24:15 -0400
Received: from mout.gmx.net ([212.227.17.21]:53645 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232539AbhGOSYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:24:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626373280;
        bh=02gMjgc2K9gYwd407ntYK+2gF+dtqhePXBo+7YsHd4c=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=S4ZduJ3ah2o+KrNKtFOFwZlY4hmvlR11orxh0IvTUyzT93BqISyMF2sRTLpDBPeCX
         x7SLegwuHBsViJIr6o8JKI8YbhHFlEqKTUcfuUCpwo+kkg9yeDfFuDO3CndhpRSx5R
         sqE9EXw97hf1qxluwXUixjb36tVZxc9qB4F88ysg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.6.56]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MDhlf-1lxBYd2IGF-00AqQQ; Thu, 15
 Jul 2021 20:21:20 +0200
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-ID: <353f9514-a5e3-e5b1-f63a-a20b87c269f6@gmx.de>
Date:   Thu, 15 Jul 2021 20:21:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:haKj5qLxnJiEGYV9CsbGlJV3pT7DKk+c45/YnPwxgu2PuO+Gbib
 yxL4s0GBcqcMBMLlxteifyqWiifa2PY21LgE4HlFnUMiicutePXpjEyTHse2O6QtbdJI3+q
 vylPMRJ0pzu/FlOHLrMPOTQDZh3MPREWRo0vgDac+vRkln7ayPYy6qVhks4lOV2teNdSY7e
 vKnG6QWL8WIeDbTa32PpA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OmJkJVCoMOo=:GVxqrBC+02//ovTLq3ZOuP
 I1hUoqglNx7EOrskGDjgB9cYgzX3p66dHvW0ZXbhvoVBq0Bj23WCuU2IciVqeSKOHp071AZWU
 dYCcdL9Dg1tlkTBwQfqv0QCbw44LIhZuFWHSnOYQ4pxgCV5MOVthwN5BVWckLG6UeAF+5rlon
 pD8mCCyLMKdYIgkguPhl1+/mFNYKQntvzhvkTOc0EPiu2FyQ5h8hLsIrBMqmKXVEc8gJAnu/v
 cdtHIeIyJ9detV/o1VeeJWaX6JWskzXCkOjXciZHlLXN4SSPQBeGtOl+aHOQDkAcIrsU0Fujj
 PgT9wx3Y1YJMAMWv/3ROvNDT2tEoSSsgtyamnIAETG3Vhv9Bf+L+gnRDk70Ny20A/FvUsqHRz
 xldvH93XjaSQMg+zqDRNNXxGRR/e3nToJS6NeGCPPh9cEoIR5Gxv04fkwaQ04GvCoSW4iHvdd
 3O6eY2UaO6rZmHubGkyaLPMxMY4OlfjOqzSKTkzivCZwsL54h7+4BMOiqDCehm1oUextSjmnV
 mxyYTM4TeD9ij//p723UWQOC6IVGumPaQ3XLAW+y12BG+J9bCEwCKwYqocbP10DykQ+HQBrB3
 9vtHrDQkleWCYFZDqR66mmGKb4ParECnaC1AXgT9HfRXtesRIxREccT7mmfPf1/6BNDd+aVey
 v0mIFW54f7EcEq3WA/x5w4gpDDmxzwOLPj6tZbtSU6xyxYHRo2A/Otc6Ur83myIdw38QmmdUG
 ptq9sNd1kwaUCluTnkB7S8jo1CiUGYrYsshesi8Eyqx1tsxmJ+HCqrfww9umlgSx38ug4R7SO
 Gmkih2FtDvverQiegXc9UOEomE8WS8ZfMR8o5y67Sjlqxh1/HCA/oayoEhVlxJkE0o8g5gXxL
 5lXlwiAKafzW0598CUirOUe9LOqgMNGUaf4LDBT6KFTqQNW522zQzEU52lKyyaUhdCEhGVW33
 /IexPjpfO2kamXbZnGqGyPPg1zyzZosE3nv0QdlCcnhKrPtke+YGiu1hLSMA/c57ItqbgMPvp
 wS0eiK40mRyj3rSALJhatZJKYmATFnOPji13jNkrWSG21ga6/Uw2tTmtzfh6QgY63bnjjAaRb
 +SKKQxQlCDvuFN9FcX8kI9P4r5bjMD/Hfkd
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo

--- snip ---


+++ UPDATE 2 +++
################

all nice again with 5.13.2 release
thanks

---
regards

Ronald
