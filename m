Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A146594E9B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 04:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiHPCWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 22:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiHPCWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 22:22:16 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6945725E6DC
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 15:35:20 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FLPaTu003013;
        Mon, 15 Aug 2022 15:35:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=Gsro6KYHG6NY9HmIcgeF7QNNBX39o7XJefvaaWZfoxo=;
 b=H/HtH7Kavp8HgOyg2YYMw15eiUOm3uJyellmnOYch+8G9wgxb2KLr4alQftfp+xGW/WP
 cPkkhra+StJSYpxtThxCK80kNebeWxprbkCWd4ukZpXD4rmcBmgy4/SvZlsOji2nLzkl
 h8rykLiWzvyFgj5csJs6fpVvuzT3xvbgpQRR9iAEUeJlt8J71zWCdhjiIP+9PCCpX6R0
 tMgn6AlfgvVWFDCUB/d4ixG2lbyBm3MTI9jNtfJUGUToehSl7Q1eZQpiCwRKiihsD3+L
 A3yXZfHajnCnOe277o0fmS6F1XtAohxA7S+BYT7g4BAgxBQYmpEdHyJQ60lsrtwzCm+W 2w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hx9aq930e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 15:35:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 15 Aug
 2022 15:35:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 15 Aug 2022 15:35:11 -0700
Received: from mvluser05.qlc.com (unknown [10.112.10.135])
        by maili.marvell.com (Postfix) with ESMTP id CE7D75B6956;
        Mon, 15 Aug 2022 15:35:11 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by mvluser05.qlc.com (8.14.4/8.14.4/Submit) with ESMTP id 27FMZAjA002601;
        Mon, 15 Aug 2022 15:35:11 -0700
X-Authentication-Warning: mvluser05.qlc.com: aeasi owned process doing -bs
Date:   Mon, 15 Aug 2022 15:35:09 -0700
From:   Arun Easi <aeasi@marvell.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <himanshu.madhani@oracle.com>, <martin.petersen@oracle.com>,
        <njavali@marvell.com>, <stable@vger.kernel.org>
Subject: Re: [EXT] Re: WTF: patch "[PATCH] scsi: qla2xxx: Fix response queue
 handler reading stale" was seriously submitted to be applied to the 5.19-stable
 tree?
In-Reply-To: <YverHtqNRmMLXmqb@kroah.com>
Message-ID: <e43fa407-31bd-8e7c-c847-87f13bdd2b73@marvell.com>
References: <166039743723771@kroah.com> <YverHtqNRmMLXmqb@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: _ljFnuosm42LPBoWc9xlFA_gRfMAnXxj
X-Proofpoint-ORIG-GUID: _ljFnuosm42LPBoWc9xlFA_gRfMAnXxj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sat, 13 Aug 2022, 6:46am, Greg KH wrote:

> 
> ----------------------------------------------------------------------
> On Sat, Aug 13, 2022 at 03:30:37PM +0200, gregkh@linuxfoundation.org wrote:
> > The patch below was submitted to be applied to the 5.19-stable tree.
> > 
> > I fail to see how this patch meets the stable kernel rules as found at
> > Documentation/process/stable-kernel-rules.rst.
> > 
> > I could be totally wrong, and if so, please respond to 
> > <stable@vger.kernel.org> and let me know why this patch should be
> > applied.  Otherwise, it is now dropped from my patch queues, never to be
> > seen again.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > >From b1f707146923335849fb70237eec27d4d1ae7d62 Mon Sep 17 00:00:00 2001
> > From: Arun Easi <aeasi@marvell.com>
> > Date: Tue, 12 Jul 2022 22:20:39 -0700
> > Subject: [PATCH] scsi: qla2xxx: Fix response queue handler reading stale
> >  packets
> > 
> > On some platforms, the current logic of relying on finding new packet
> > solely based on signature pattern can lead to driver reading stale
> > packets. Though this is a bug in those platforms, reduce such exposures by
> > limiting reading packets until the IN pointer.
> > 
> > Two module parameters are introduced:
> > 
> >   ql2xrspq_follow_inptr:
> > 
> >     When set, on newer adapters that has queue pointer shadowing, look for
> >     response packets only until response queue in pointer.
> > 
> >     When reset, response packets are read based on a signature pattern
> >     logic (old way).
> > 
> >   ql2xrspq_follow_inptr_legacy:
> > 
> >     Like ql2xrspq_follow_inptr, but for those adapters where there is no
> >     queue pointer shadowing.
> 
> On a meta-note, this patch seems VERY wrong.  You are adding a
> driver-wide module option for a device-specific action.  That should be
> a device-specific functionality, not a module.
> 
> Again, as I say many times, this isn't the 1990's, please never add new
> module parameters.  Use the other interfaces we have in the kernel to
> configure individual devices properly, module parameters are not to be
> used for that at all for anything new.
> 
> So, can you revert this commit and do it properly please?
> 

The reason I chose module parameter way was because of these primarily:

1 As this is a platform specific issue, this behavior does not require a 
  device granular level tuning. Either all the said adapters turns the 
  behavior on or off.
2 Module parameters allowed persistence without complexity: Since this 
  adapter is also used in booting on some environments, module parameter 
  allowed the configurability as well as simplicity.

If the above approach is discouraged, the alternatives that comes to my 
mind are:

1 Add a sysfs node 
2 Add a debugfs node
3 /proc/sys/kernel ? (but that is not per adapter specific)
4 Add a udev script to watch for PCI adapter addition and set/reset 1, 2 
  or 3

If udev route is taken, I'd have to come up with a configuration file to 
save tunable state, which could be a bit cumbersome and needs 
documentation and be different (in terms of script location/submitting) 
distro to distro.

Are there other options that you have in mind? Please do tell, if so.

Regards,
-Arun
