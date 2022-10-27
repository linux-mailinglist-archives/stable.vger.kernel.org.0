Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA1A610120
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 21:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbiJ0TIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 15:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbiJ0TIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 15:08:01 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D770466A68;
        Thu, 27 Oct 2022 12:07:59 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5b07ea35.dip0.t-ipconnect.de [91.7.234.53])
        by mail.itouring.de (Postfix) with ESMTPSA id 29A30103762;
        Thu, 27 Oct 2022 21:07:55 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 7AA85EEB63F;
        Thu, 27 Oct 2022 21:07:54 +0200 (CEST)
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221027165057.208202132@linuxfoundation.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <e5d591a0-5052-0d69-648a-8b3fa08191ff@applied-asynchrony.com>
Date:   Thu, 27 Oct 2022 20:46:14 +0200
MIME-Version: 1.0
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-10-27 18:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Looking good on various x86-64 machines (desktop, server) and
my Zen2 Thinkpad. Btrfs still works, too. :)

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

cheers,
Holger
