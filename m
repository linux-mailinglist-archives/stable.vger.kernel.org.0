Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C563B6042B8
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbiJSLJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJSLIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:08:37 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2323A133305;
        Wed, 19 Oct 2022 03:37:34 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E1EF468C4E; Wed, 19 Oct 2022 12:36:30 +0200 (CEST)
Date:   Wed, 19 Oct 2022 12:36:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 659/862] =?us-ascii?B?PT9V?=
 =?us-ascii?B?VEYtOD9xP0FSTS9kbWEtbWFwcD1EMT05Nm5nOj0yMGRvbnQ9MjBvdmVycmlk?=
 =?us-ascii?B?ZT0yMC0+ZG1hPTVGY29oZT89ID0/VVRGLTg/cT9yZW50PTIwd2hlbj0yMHNl?=
 =?us-ascii?Q?t=3D20from=3D20a=3D20bus=3D20notifier=3F=3D?=
Message-ID: <20221019103630.GA25051@lst.de>
References: <20221019083249.951566199@linuxfoundation.org> <20221019083319.087440003@linuxfoundation.org> <Y0+/41/qY8DjVn23@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y0+/41/qY8DjVn23@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:14:11AM +0100, Russell King (Oracle) wrote:
> I'm seeing:
> 
> Subject: [PATCH 6.0 659/862]
>         =?UTF-8?q?ARM/dma-mapp=D1=96ng:=20dont=20override=20->dma=5Fcohe?=
>         =?UTF-8?q?rent=20when=20set=20from=20a=20bus=20notifier?=
> 
> in mutt, and mutt seems to be unable to decode that. Either a mutt
> bug or a bug in your scripts or git...

The real problem was me fat fingering the comments and adding a non-ASCII
"і" character instead of and "i" into the Subject.  And then it somehow
went downhill from there..
