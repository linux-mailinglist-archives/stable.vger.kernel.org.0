Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5433E57070D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 17:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbiGKPZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 11:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiGKPZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 11:25:29 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D36275C0;
        Mon, 11 Jul 2022 08:25:26 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5b07e355.dip0.t-ipconnect.de [91.7.227.85])
        by mail.itouring.de (Postfix) with ESMTPSA id F1215125BD3;
        Mon, 11 Jul 2022 17:25:22 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 9FFD6F01600;
        Mon, 11 Jul 2022 17:25:22 +0200 (CEST)
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220711090549.543317027@linuxfoundation.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <36be91a5-d88f-e0d2-fcff-a496244a8186@applied-asynchrony.com>
Date:   Mon, 11 Jul 2022 17:25:22 +0200
MIME-Version: 1.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-07-11 11:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.11 release.

Running on a variety of machines & various configurations
(server, desktop, laptop)) without any issues. \o/

Thanks!
Holger
