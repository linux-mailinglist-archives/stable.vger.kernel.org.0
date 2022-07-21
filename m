Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1D857D3A8
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 20:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbiGUS4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 14:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbiGUS4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 14:56:01 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0160488F2A;
        Thu, 21 Jul 2022 11:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1658429758;
        bh=bsUMZaftZOZZ6dyjR0D9oZKDcxxJEJJ2jeYm5vBBg1o=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=F+NUvT6aFho8Bp8MX9IUm4+W0tTMVS9+B4WIEmI+Mt1xSHsJcLF/zFZaG9S7LyrjK
         WS0SeduP7pFIU/o4Qx2cEjCmI+GYupiBAQVSmCB6Qk0By38mQzagdCpZMJ0VWvemEs
         j4hg/jgzxBkUZxTX9Nx4NajqTmJ5cN03wd6yJxRU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.23]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M9nxn-1oB2xn19CH-005qPv; Thu, 21
 Jul 2022 20:55:58 +0200
Message-ID: <27364f72-bb70-a72c-cde2-f64d76d1d2dd@gmx.de>
Date:   Thu, 21 Jul 2022 20:55:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: re: [PATCH 5.18 000/227] 5.18.13-rc3 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:IGcXsH2EoOb9cziWUB7dz7KQzo/EhqUHnkT5rMSss/TJodDMn2B
 gghK2b7/xUnaQ9NiZ+oRnZ+IqXtK9uzdPso4nyAjHNE6nEuXhJnN5iyvKRsOwZGd9fdtaMN
 wuEciG+cAj+5L2E60jMkAFK+H3t0Jcorlfn3ZxL++Wou4iKvR6HZaM5zBqw5epuX/uu/n2B
 aerAXLKg5s7wgB9I3+iig==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tjCWQ4Ppf9I=:+JKcGs3Ei0qVmYwJ/CkoPJ
 pjGyn0fsgNceqgtH55hET4i7MWtm/JrdeTxYR+ZrFtQujcjuEncjj9ozcE5R6aWUIh+Cnzr+T
 yJzDyut3nd0M4PAZBG+MqIn9QBXx/pVqAAbsx/4h/CfU0KFRqF5IeK6qOuz00zNO5t40e4sqr
 pA60KBuI//buNiIbY5gLNYhyAngCbXlPXkohy6+ho7y8H7T8ouUF+J1xwTedfPwpa/Cq6ELxY
 RDhEWSo1g/RN38ab835mCHKq6yDz98RcFiNAhAmChMeCZl8SRlAt5ODqOX32G6b1j/LrZhRFm
 2xKyM7BEI+tRiQPriOWnxCqzSTBQMXd9YHGoFQ8wVnK4xltarG9Kj2RB2HNRqbKdodTewgqT0
 MxYTVhQmZbuxZHTzCQ0wea1824xlaXWX1ZLRCqxHmsRakVcaWAWOpms9be5LKlkuBihhX0noi
 PxPnlg6Gboe54khr/G2qa17m8QB4BWR2lSNFoB72JhXM6AMZKBpgRFfLA8jK6gY/PWsaW+q1W
 rcEQPoVrhKa61mndEGFGSl9WNKbyp0PSa+C+oFWs6HxRl2+go74wPBJBkxeF5777u473W4+Es
 UHevYB30hOfYS/sEDu7DsNcsvtn5oBkMcUMpc/tvrBtXLk6NrbrE4geG7D89hEWzJDO4LrOyg
 wO95zKWFEDxTrO3FX/m+vE4mUuJwu4lRANb0Sg8sNkU1KfjVxfi39ELhB+EB8BhMdLXeTcXUU
 cAFh0TemG1EI2by5zXUjeXVoi0tWaNHnXXX4UKUleAy+RpRFZS1kLxVQgIZk29X0g6zoUhytg
 cfC9KmlTRlkEUurc2J41PbRj9wpcEYhFIFgb/F/wmxZDlIvzwoNgzZTDlMQ+xx60MzvmpZdj8
 G4sYom1SXW8l5qcVJykI9RgsBgkIFcKz22gjVbr1LEWgE5x70kBB35tc4gQHwAJRUnRGSJDd5
 fkoCrHM0yZAb3YcK/s774CObhVGoc//gXj3zgNVKz4zoS1ULX5SbdWuoQ6ZBYLa+zZxo3haeA
 Cf21HiZpGM86dekpHW376pJQMTnAHrDacZQ5nwIq2shgy7cq4yXt4h85PQSMp1haUdp3mDwqj
 4YyiejpNutywaXBzuHjPvgwEtuqJvaJyPbH
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.18.13-rc3

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

NO "'naked' return" errors anymore !

regarding "heat errors": get some "pool & pivo" and have a break
;-)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


