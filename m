Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53816278E96
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgIYQbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbgIYQbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:31:23 -0400
X-Greylist: delayed 563 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Sep 2020 09:31:22 PDT
Received: from mail.enpas.org (enpas.org [IPv6:2a03:4000:2:537::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB16AC0613D3;
        Fri, 25 Sep 2020 09:31:22 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 1B7AEFF8A3;
        Fri, 25 Sep 2020 16:21:56 +0000 (UTC)
Subject: Re: [PATCH] fs/affs: Fix basic permission bits to actually work
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        David Sterba <dsterba@suse.com>
Cc:     linux-fsdevel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200827154900.28233-1-max@enpas.org>
 <c96b8ee5-5e96-07fd-de69-ffaa2a4f3bc6@physik.fu-berlin.de>
From:   Max Staudt <max@enpas.org>
Autocrypt: addr=max@enpas.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <24d77b0f-ecda-20ea-5c86-09dd4555434e@enpas.org>
Date:   Fri, 25 Sep 2020 18:21:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <c96b8ee5-5e96-07fd-de69-ffaa2a4f3bc6@physik.fu-berlin.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/25/20 12:07 PM, John Paul Adrian Glaubitz wrote:
> Has there already been any progress on reviewing this?

It has already been merged, and the maintainers have been so kind as to backport it to all maintained stable branches.

Thanks for your help, everyone!


Max
