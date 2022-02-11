Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFD64B24E7
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 12:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349683AbiBKLzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 06:55:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349682AbiBKLzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 06:55:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC847EBD
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 03:55:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAC01B829B2
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 11:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2962C340EF;
        Fri, 11 Feb 2022 11:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644580497;
        bh=pPySnO6f+V64uJcbhDmn1n6corpQ21751qID5yfJxy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r3EruNwEgmPjUsFcF/dFF3Ie9ntDhdK1LDx/cR/DxYCIA3+j70mme0trLGoLbGEVh
         la8ZfRDEk3L4kymoBPPxpsj2AC2cUfwzDu+8HRH160o7U5mxLruJ8n4ai617zWJjI1
         onMfD/blBdE2NNLBDSkSzrbWLZGDFjMgQcwpCx2o=
Date:   Fri, 11 Feb 2022 12:54:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     zanussi@kernel.org, rostedt@goodmis.org, ykaradzhov@vmware.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Propagate is_signed to
 expression" failed to apply to 5.15-stable tree
Message-ID: <YgZOjjOC5PgdWs3f@kroah.com>
References: <16434604001373@kroah.com>
 <YgQrT+dZfEvlgEmt@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgQrT+dZfEvlgEmt@debian>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022 at 08:59:59PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sat, Jan 29, 2022 at 01:46:40PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Both now queued up, thanks.

greg k-h
