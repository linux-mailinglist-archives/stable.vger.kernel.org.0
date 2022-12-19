Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBD365138A
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiLST6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiLST63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:58:29 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C32510FEA;
        Mon, 19 Dec 2022 11:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1671479906; bh=i+f4d/Si53rzglv7PMIEM+OxgEO+cRX80m33pXb3pNE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=t5BnMz9oqKIXOVixMSgK4ca5LKCstRcsxV881tqn3MnDik0kGsQz7inTnd+A6fsDD
         MVHh3B/FjGCB204gBC72c36HVyV6/CmRkbkR2o+xBviUYCgwv2+07bUP0wJ70sOrgx
         bS/HsAm70YtFMVEaO2F9ohHcbJatg2eRHYrtK9x3lmRylrTrYO0JDjHLn2OmI6WWM5
         xhfcBxz5446v8/61LgKXQP+Yp+06/lxoCcYkCV/pjWVY1i36pnBJPUePAUE0qV0lIQ
         6VVz/UIsDGwllWbT9gw+1NC23PK6TBo38QT9gv0BzXXaFG1zjsAEcNv0w55y8cahId
         4Z2PYXCCCsqfQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.134]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N79uI-1ooWB41vwK-017TV3; Mon, 19
 Dec 2022 20:58:26 +0100
Message-ID: <ce3f3e97-fd58-da96-9e2e-735d20abad69@gmx.de>
Date:   Mon, 19 Dec 2022 20:58:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:R2/yFToRqHv7kiV79nWVCJUfyIRW0xeGkqADhCguTWxsOT74Ap+
 j2YVpfSSV0ppPQ1OUCaecC6ElvyWNy3k19S+vdHCMkUzbTDETIoxNOFL5yA4HvQ9D+KEfcA
 I59XelTTtqVt0BPYiRKi47JLBWQXNA6jqBtD4KD9SHoQxduQkiUV+Zla1RI1beI/z1kyUWx
 EunsaJ5kz0IXanzrJujOA==
UI-OutboundReport: notjunk:1;M01:P0:dxpzJ/pqmh8=;p8cUn8ush4hw8tcrtmF+B1hUwgi
 PxL2lBwtVaXMV/gly4srxbC9U4UXLtzwpvrE+bD5E4lYJEcnKe+BvBp3/CfrYT2HZBWmgI+8P
 PrVZ88u0xcxX8fKsKHvPCDToaWmV9B+r2mv8yrg2ilG2evV2C73KEBpRc337XiXHgKY+I8YP/
 AOsTjksqRxOq9wh8pVOrx6EExXrlNkTJJKlr80XCV6ML91wwxx/p3SWmMzERQYGS4mpn+bs/B
 oaRjJkZyuv9MFRYVFtkU7wKdOfGOSkEDTjqbU3QSWp/3CgWA/+IoMroRlE+d2Fp+6+FYvLwQz
 7XGxcse9GKnwanrUbbZ2hf2YShatpMEFTYvGOukjo6WhSYJcjs2DGpywdBt15ZZ5IfdwlpZrd
 aBGYT+6K3FVYcWqdIFhWWQ25/z/y71wqbqE9dYwF4Q+gDbXFGpqezWkRiX99dJAfHhbk8mYpZ
 qCVdynt6UUmQLhB7wEt7TAb2R6Q9uGLBK4CVx/S5TLY2htWrKLh1xizijWRHrGt6YFzIxoLl0
 r/WsP2WhDGk0AtT85zYqF3B8wKCjcgUbSFW4vmdH2pTriFuvT6I0MI1RYLJzMNdYqFlSCHEGj
 OEL5Wl2tge29Xr8A+vO6vGSzWjHXloYxMyLZxi8PZfrPfkj8EU78961UiBmdXnvTbSYzKbwig
 krpN5iHglr5WxBdtTFPJ5m4rU/S7Qg+kUfHgymRWtuqXbIVmzhbWbfEoj8FQDpeUfpx0t5EYM
 7IXOhzFV3EfDsO7dT7Mj9DiRyyWMiRixumR2rZYhnouqWm+1fEOT12TS3Fz8biFxd8YPk2Yxz
 73flJmfjOgyaGPjbcI3FEI3eVNI7lv21W0CN6dehUUJFauXK3MnbLHmLJPCUtKUVm5qoNbmLC
 V/cscHoOZpsPwsFK9cKHH8jRzZKjYg5iEJa2+OUlkj6qGHNzvuRIiP41ZR9zCC+tcmv3mVwQ5
 J9/3r7C1p+snqAYk/RULJ+mAJLU=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.1.1-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

