Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5A34EECB8
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 14:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345707AbiDAMDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 08:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345706AbiDAMDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 08:03:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4E926A962;
        Fri,  1 Apr 2022 05:01:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A21DCB824B1;
        Fri,  1 Apr 2022 12:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DDBC340F2;
        Fri,  1 Apr 2022 12:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648814511;
        bh=kahVl7bmdOb64PF4PvuPVKhOEp8o4fLjnqzNqhy6L6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TH70ovodK279Ao29zY7QwkEW+HI1HOZoXQbdMScuQBiqaXF54R6WuQiUNOlLUZNAu
         tqGXF5wuxnQ9/V4JvyAuzmTdeqQl6uGpo1qtwuPctmVCbTIEt3fRHYqN0icrNOUuNj
         YMDytqgQn+QduJWh69ob5fvsZdp1TlNvycwV5pI8=
Date:   Fri, 1 Apr 2022 14:01:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hui Wang <hui.wang@canonical.com>
Cc:     stable-commits@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: Patch "serial: sc16is7xx: Clear RS485 bits in the shutdown" has
 been added to the 4.9-stable tree
Message-ID: <Ykbpm1w9SwcR3uT1@kroah.com>
References: <1648809520213199@kroah.com>
 <5d0c62ac-0c43-c8d9-4812-d4ddbfb5b225@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d0c62ac-0c43-c8d9-4812-d4ddbfb5b225@canonical.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 01, 2022 at 07:51:53PM +0800, Hui Wang wrote:
> Hi Greg,
> 
> Sorry, please don't apply the patch to stable kernels. I tried to add
> "linux,rs485-enabled-at-boot-time" support for this driver yesterday and
> found this patch is not correct, I will send a patch to revert this patch
> from the mainline kernel.

Now dropped from all queues, thanks for letting me know.

greg k-h
