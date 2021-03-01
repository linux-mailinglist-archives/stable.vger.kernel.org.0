Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32C8328EFA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbhCATl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241720AbhCATdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 14:33:17 -0500
X-Greylist: delayed 415 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 01 Mar 2021 11:32:37 PST
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EFBC06178A;
        Mon,  1 Mar 2021 11:32:37 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5b07e8e5.dip0.t-ipconnect.de [91.7.232.229])
        by mail.itouring.de (Postfix) with ESMTPSA id CC97E11DD5E;
        Mon,  1 Mar 2021 20:24:39 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 31D37F0161B;
        Mon,  1 Mar 2021 20:24:39 +0100 (CET)
Subject: Re: [PATCH 5.10 000/663] 5.10.20-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210301161141.760350206@linuxfoundation.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <07d44f9a-4789-3f7a-20af-67a05b93e15e@applied-asynchrony.com>
Date:   Mon, 1 Mar 2021 20:24:39 +0100
MIME-Version: 1.0
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-01 17:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.

Since this is a big update I gave it a try on my two older SandyBridge
server/desktop systems and a Lenovo AMD Ryzen7 laptop.
Good news: all three still humming along nicely.

Thanks!

-h
