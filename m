Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B0F56CEA8
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 13:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiGJLG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 07:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiGJLG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 07:06:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EF613DDB
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 04:06:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25B31611D8
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 11:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120C3C341C6;
        Sun, 10 Jul 2022 11:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657451213;
        bh=AjQIK2gXevj1s+/+VOgWvZePLAPdK07KiDk5x1upPy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cir48+naYhkrqSrxe+uj6N1nbnxkBasrvImDPgT9WCWGNtfksVCtj3iCuJujtGRJq
         fXFiHS7rvh5JF/qMIcu3OJPsXvKeXX6lf8CEmn+vrOL9kLjGud9F7gxtMWLpiAF3Zu
         yTW+h977Gm70cHbHXBGxz/Z66J9DoKVMHstoOB9E=
Date:   Sun, 10 Jul 2022 13:06:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [GIT 4.9] LSM,security,selinux,smack: Backport of LSM changes
Message-ID: <YsqyxydY1kbufgng@kroah.com>
References: <4230dd79-b64f-14e6-3614-02e4acb3f284@gmail.com>
 <YslxiluWV9YnPPAY@kroah.com>
 <81f96354-cbed-26e4-9f3f-5287095ccece@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81f96354-cbed-26e4-9f3f-5287095ccece@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 10, 2022 at 12:44:34PM +0200, Alexander Grund wrote:
> > Please just send them to us in patch form like all other stable
> > submissions.
> 
> Sorry I'm new to this kernel list. I'll send 1 patch of this series in a new mail (as a test).
> Please bear with me if there are any mistakes, the next ones will then be better.

As my bot says, this is all documented:

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

Make sure the patches you are submitting follows those rules on what is
able to be accepted.

> The Civil Infrastructure Platform (CIP) e.g. maintains LTS kernel trees which are now End of Life but still used.
> They call that SLTS ("Super Long Term Support") and there is e.g. a 4.4.y branch with backports from the 4.9.y LTS branch.
> That kernel is e.g. used in many Android phones.

What 4.4.y Android devices are still supported by their vendors?  And
are they still getting kernel updates?

thanks,

greg k-h
