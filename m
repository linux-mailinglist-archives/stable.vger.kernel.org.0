Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F1553B51E
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 10:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiFBI3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 04:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiFBI3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 04:29:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AC1BD1;
        Thu,  2 Jun 2022 01:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A853B81EE7;
        Thu,  2 Jun 2022 08:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89790C385A5;
        Thu,  2 Jun 2022 08:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654158583;
        bh=BN4ioYNda/zi1dUexn63v19SN0dic1eefabXoCOtF/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDxZymjw2BgFZlHAEzqWseLq8V13tknkA7ow/IGnxZS780a8ozkQILk85azdoYV37
         Ba28hnTd+6sz8ee0vUxEoJGgTBlQve768PCxL4rl6irsntMm0MOSasfy9aRYUzskjT
         Ft0tquR1j5LEAwXWyOQPj4M3R2IV2Ab9AdGaECPM=
Date:   Thu, 2 Jun 2022 10:29:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>,
        Nikolai Kondrashov <spbnick@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] HID: uclogic: properly format kernel-doc comment for
 hid_dbg() wrappers
Message-ID: <Yph09N8w4g7+d9ER@kroah.com>
References: <20220602082321.313143-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602082321.313143-1-bagasdotme@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 02, 2022 at 03:23:21PM +0700, Bagas Sanjaya wrote:
> Running kernel-doc script on drivers/hid/hid-uclogic-params.c, it found
> 6 warnings for hid_dbg() wrapper functions below:
> 
> drivers/hid/hid-uclogic-params.c:48: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Dump tablet interface pen parameters with hid_dbg(), indented with one tab.
> drivers/hid/hid-uclogic-params.c:48: warning: missing initial short description on line:
>  * Dump tablet interface pen parameters with hid_dbg(), indented with one tab.
> drivers/hid/hid-uclogic-params.c:48: info: Scanning doc for function Dump
> drivers/hid/hid-uclogic-params.c:80: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Dump tablet interface frame parameters with hid_dbg(), indented with two
> drivers/hid/hid-uclogic-params.c:80: warning: missing initial short description on line:
>  * Dump tablet interface frame parameters with hid_dbg(), indented with two
> drivers/hid/hid-uclogic-params.c:80: info: Scanning doc for function Dump
> drivers/hid/hid-uclogic-params.c:105: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Dump tablet interface parameters with hid_dbg().
> drivers/hid/hid-uclogic-params.c:105: warning: missing initial short description on line:
>  * Dump tablet interface parameters with hid_dbg().
> 
> One of them is reported by kernel test robot.
> 
> Fix these warnings by properly format kernel-doc comment for these
> functions.

None of this is needed for stable kernels releases as no code is being
modified.

thanks,

greg k-h
