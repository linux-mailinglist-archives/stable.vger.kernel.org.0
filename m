Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AC8664C8E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 20:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjAJTe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 14:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjAJTeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 14:34:22 -0500
Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEA91EEFC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 11:34:21 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5ddd742f.dip0.t-ipconnect.de [93.221.116.47])
        by mail.itouring.de (Postfix) with ESMTPSA id 95A87127843;
        Tue, 10 Jan 2023 20:34:18 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 42A58F01581;
        Tue, 10 Jan 2023 20:34:18 +0100 (CET)
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
References: <20230110180018.288460217@linuxfoundation.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <20dae09e-aab7-bbe5-8386-a01f13fea76c@applied-asynchrony.com>
Date:   Tue, 10 Jan 2023 20:34:18 +0100
MIME-Version: 1.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
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

On 2023-01-10 19:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No behavioural or dmesg regressions on x64 (server, desktop) or my
AMD Zen2 Thinkpad; humming along just fine.

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

Thanks!
