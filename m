Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C6454A989
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 08:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbiFNGe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 02:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiFNGe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 02:34:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8904733A01;
        Mon, 13 Jun 2022 23:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1998760BC3;
        Tue, 14 Jun 2022 06:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03101C3411C;
        Tue, 14 Jun 2022 06:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655188496;
        bh=tLkhwbbP24fAPSP0wvidXO3oYvnqe+3wnCwUvm0RvJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GeGFmUlXmkRtNA6KtrY8dg3GvQcsYXkx+tzeX2G8vtPvuGf8LsJPWbWI+6lAPL3xv
         Cqb7wMNSlTgRdwA8iCbvkdA4THCTv178VMzIZ//UGD4K+MwLqa3k4DamWCifgHvLtn
         sh5HQ+lXd24A0NIuu7AwMZutKLzfrOrkX3oZUujo=
Date:   Tue, 14 Jun 2022 08:34:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
Message-ID: <YqgsDXdY3OttH8Mc@kroah.com>
References: <20220613181233.078148768@linuxfoundation.org>
 <CAK8fFZ68+xZ2Z0vDWnihF8PeJKEmEwCyyF-8W9PCZJTd8zfp-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8fFZ68+xZ2Z0vDWnihF8PeJKEmEwCyyF-8W9PCZJTd8zfp-A@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 07:56:36AM +0200, Jaroslav Pulchart wrote:
> Hello,
> 
> I would like to report that the ethernet ice driver is not capable of
> setting promisc mode on at E810-XXV physical interface in the whole
> 5.18.y kernel line.
> 
> Reproducer:
>    $ ip link set promisc on dev em1
> Dmesg error message:
>    Error setting promisc mode on VSI 6 (rc=-17)
> 
> the problem was not observed with 5.17.y

Any chance you can use 'git bisect' to track down the problem commit and
let the developers of it know?

thanks,

greg k-h
