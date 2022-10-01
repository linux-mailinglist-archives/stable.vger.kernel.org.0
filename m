Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B172E5F1A6F
	for <lists+stable@lfdr.de>; Sat,  1 Oct 2022 09:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJAHBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Oct 2022 03:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJAHBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Oct 2022 03:01:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C266631D5
        for <stable@vger.kernel.org>; Sat,  1 Oct 2022 00:01:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 361EEB80B40
        for <stable@vger.kernel.org>; Sat,  1 Oct 2022 07:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEB1C433D6;
        Sat,  1 Oct 2022 07:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664607674;
        bh=5LMO+mvVw/CnAgVQkF5pIZXhkacoh3yfBvA8U+6JqsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AZV0yGI8MW7ATQ3RF5Su4V+PUVwSjfGvCCPhfEe4UN4a+Dx4P31qZIYpjtZEkchWf
         Ju2xnZt9xEMp/+RMWztB66o6gnc73zb8+4JxiKz0bV1KqEk7HE5Nc6izj1B8i0xBh3
         FcwrwImngCp0D4XQtm8Jd7LMfOViaZn6DBiVuZBs=
Date:   Sat, 1 Oct 2022 09:01:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] wait_on_bit: add an acquire memory barrier
Message-ID: <Yzfl3yCpo3eq2UIj@kroah.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2209301134350.23900@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2209301134350.23900@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 30, 2022 at 11:34:55AM -0400, Mikulas Patocka wrote:
> This is backport of the upstream patch 8238b4579866b7c1bb99883cfe102a43db5506ff
> for the stable branch 4.9
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Again, you lost all of the original changelog and authorship/review
information here :(

And what order are these to be applied in?  Please make a patch series
for each stable/LTS tree they are to be backported to.  Would you want
to try to unwind this if you were the reciever of these emails?

thanks,

greg k-h
