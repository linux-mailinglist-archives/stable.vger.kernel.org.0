Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC344E241F
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 11:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbiCUKTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 06:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346259AbiCUKTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 06:19:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A89B9AE6D
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 03:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D838B811C1
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 10:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F997C340E8;
        Mon, 21 Mar 2022 10:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647857852;
        bh=teDYYYjeZwL4uuS3Mh50NySSmL/5qFuw+pj1QSzqPD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dbpvxp2APQ1Mv2RA842ITfnUXFK8aoCVatD0Az8eE8D0iyNcFJcp/2ktcoU6EHlTx
         kAc7NPO2Kw1VYD2G7wq40bTf8J/JIMZEfH3juBcJf+GK29m+NCvXpqaSGqmdPMvJ5h
         LQwlbpL4aLi3zgqrw9R8BVTZwZix/X1Vj7OPWez8=
Date:   Mon, 21 Mar 2022 11:17:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     stable@vger.kernel.org, tglx@linutronix.de
Subject: Re: The linux-5.17.y tag looks bogus.
Message-ID: <YjhQuSYxLBVc+kJC@kroah.com>
References: <YjhPvcJ9opIrx+ua@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjhPvcJ9opIrx+ua@linutronix.de>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 21, 2022 at 11:13:17AM +0100, Sebastian Andrzej Siewior wrote:
> Hi,
> 
> I just noticed that the stable repository has the linux-5.17.y tag and
> no branch with the linux-5.17.y name. That tag looks like a copy of
> Linus' v5.17.
> 
> I guess this is a mistake. On my side git refused to push the
> linux-5.17.y branch because it already had a tag with the same name.

I have not created the 5.17.y branch yet.

What tag are you seeing?

thanks,

greg k-h
