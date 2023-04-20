Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8224C6E97E7
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 17:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbjDTPC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 11:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbjDTPC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 11:02:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF20C3A86
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:02:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D5786164D
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 15:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F43BC4339B;
        Thu, 20 Apr 2023 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682002975;
        bh=wLFf/3UduQT115De5anbj1jAUqCYioVOyfeOTB/iTsY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bcK31wBsQF16z3QtPGxFKKaX3N/WLgvhK3ISNENMKF1GTMr1Dl06Ruqs0q055mAxk
         +nOXXUIjpU+YYq4a11Bde6shLjTP5wRDH6RzbQ+r5l84lA7Rxx69A6dySQpk7EV0AV
         auR3fIN1I82ivpdUumVHUt/pk4uVuvCNO1N3LZ6E=
Date:   Thu, 20 Apr 2023 17:02:49 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Zhu, James" <James.Zhu@amd.com>, "Liu, Leo" <Leo.Liu@amd.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>
Subject: Re: [PATCH 6.1.y] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh
 broken BIOSes
Message-ID: <ZEFUGSlqQu3v8ryf@kroah.com>
References: <20230418221522.1287942-1-gpiccoli@igalia.com>
 <BL1PR12MB514405B37FC8691CB24F9DADF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
 <be4babae-4791-11f3-1f0f-a46480ce3db2@igalia.com>
 <BL1PR12MB51443694A5FEFA899704B3EBF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
 <9b9a28f5-a71f-bb17-8783-314b1d30c51f@igalia.com>
 <ZEEzNSEq-15PxS8r@kroah.com>
 <94b63d19-4151-c294-50eb-c325ea9c699f@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94b63d19-4151-c294-50eb-c325ea9c699f@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 20, 2023 at 09:59:17AM -0300, Guilherme G. Piccoli wrote:
> On 20/04/2023 09:42, gregkh@linuxfoundation.org wrote:
> > [...]
> >> @Greg, can you pick this one? Thanks!
> > 
> > Which "one" are you referring to here?
> > 
> > confused,
> > 
> > greg k-h
> 
> This one, sent in this email thread.

I don't have "this email thread" anymore, remember, some of us get
thousand+ emails a day...

> The title of the patch is "drm/amdgpu/vcn: Disable indirect SRAM on
> Vangogh broken BIOSes", target is 6.1.y and (one of the) upstream
> hash(es) is 542a56e8eb44 heh

But that commit says it fixes a problem in the 6.2 tree, why is this
relevant for 6.1.y?

thanks,

greg k-h
