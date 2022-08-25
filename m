Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B969A5A0FAC
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 13:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240595AbiHYL5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 07:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbiHYL5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 07:57:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB31A50EF
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 04:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBD76B82738
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 11:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C12C433D6;
        Thu, 25 Aug 2022 11:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661428625;
        bh=36ofyImJH4P6Zn0b+tKV/OH5hk1VWXPWFjYwwMHYljU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tJf2x2gldYPzy9dhhh0PJhZhUc4OW/FgqrlIresl912l4k/vYW6afb3Qx35nQ6gYX
         ZwEKR8p2QD8ZBFWA/DOpLltYb4oTsLQ9q1vQ7g87PYXu2dSgCwnwCwP9mVYEZUrmTK
         OzhZiO9F3lp28GDQOBCIYLmpgvoLZJ5Dvj+rrdUw=
Date:   Thu, 25 Aug 2022 13:57:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Peter Chen <peter.chen@kernel.org>
Subject: Re: [PATCH] usb: cdns3: Fix issue for clear halt endpoint
Message-ID: <Ywdjjh8n7Hp2fFQP@kroah.com>
References: <20220825111235.29250-1-pawell@cadence.com>
 <BYAPR07MB5381C9E9D86FB39C28456D24DD729@BYAPR07MB5381.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR07MB5381C9E9D86FB39C28456D24DD729@BYAPR07MB5381.namprd07.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 25, 2022 at 11:19:32AM +0000, Pawel Laszczak wrote:
> 
> Hi Greg,
>  
> It is backport to 5.4 stable version.
> Please apply this patch.

Now queued up, thanks.

greg k-h
