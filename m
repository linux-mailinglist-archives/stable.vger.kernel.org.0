Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4940E596244
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 20:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236503AbiHPSRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 14:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiHPSRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 14:17:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374A485A8F
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 11:17:43 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GGTU6C019563;
        Tue, 16 Aug 2022 11:17:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=g/KDIYC6HY7TSbs/CqTD1e4yDgRmrCtayajfDibp8dA=;
 b=cz7QooMuTEdIDMGzmPddWMEDWkUuVbGhiNGsJQ/AyhLJlGc3unNBGl+Vm3U/C38s+l1U
 J2g7bg4c2q/UMrQkXW/vNQYmAjCDgJOm/bloR98b7hs+tidm6dGFIuCjVB5G3RYFHe9n
 7nnuB1loQU64xVGOuiTPXGw7SL1OcoO4/uDJKdoD6Uv6IMS+fAYKYSSQGna2WOkleMeM
 b6xbQ5cXllWmYL+T/KHne7g/QXV4mvwhCeZ5gmRoj+WRS+e56CoO+NPVb2ifdpE8IkS5
 vAO6Jhb780qasZv8K44cAQWxB2/dhCL5N+0KSt2qLLp264QAfJC4WG4WxpQsmw1MM0VD fA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hxbfkvwrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 11:17:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Aug
 2022 11:17:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Aug 2022 11:17:39 -0700
Received: from mvluser05.qlc.com (unknown [10.112.10.135])
        by maili.marvell.com (Postfix) with ESMTP id C5FA33F704B;
        Tue, 16 Aug 2022 11:17:39 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by mvluser05.qlc.com (8.14.4/8.14.4/Submit) with ESMTP id 27GIHdms029148;
        Tue, 16 Aug 2022 11:17:39 -0700
X-Authentication-Warning: mvluser05.qlc.com: aeasi owned process doing -bs
Date:   Tue, 16 Aug 2022 11:17:39 -0700
From:   Arun Easi <aeasi@marvell.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <himanshu.madhani@oracle.com>, <martin.petersen@oracle.com>,
        <njavali@marvell.com>, <stable@vger.kernel.org>
Subject: Re: [EXT] Re: WTF: patch "[PATCH] scsi: qla2xxx: Fix response queue
 handler reading stale" was seriously submitted to be applied to the 5.19-stable
 tree?
In-Reply-To: <YvtjocfDhhPuo5Ua@kroah.com>
Message-ID: <4ed36d0a-2f82-4fe6-1f8f-25870b9e05c6@marvell.com>
References: <166039743723771@kroah.com> <YverHtqNRmMLXmqb@kroah.com>
 <e43fa407-31bd-8e7c-c847-87f13bdd2b73@marvell.com>
 <YvtjocfDhhPuo5Ua@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: EFT1fghb5j9bJy_ho56jFR1SW0SHvFiF
X-Proofpoint-ORIG-GUID: EFT1fghb5j9bJy_ho56jFR1SW0SHvFiF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Aug 2022, 2:30am, Greg KH wrote:

> On Mon, Aug 15, 2022 at 03:35:09PM -0700, Arun Easi wrote:
> > Hi Greg,
> > 
> > On Sat, 13 Aug 2022, 6:46am, Greg KH wrote:
> > 
> > > 
> > > ----------------------------------------------------------------------
> > > On Sat, Aug 13, 2022 at 03:30:37PM +0200, gregkh@linuxfoundation.org wrote:
> > > > The patch below was submitted to be applied to the 5.19-stable tree.
> > > > 
> > > > I fail to see how this patch meets the stable kernel rules as found at
> > > > Documentation/process/stable-kernel-rules.rst.
> > > > 
> > > > I could be totally wrong, and if so, please respond to 
> > > > <stable@vger.kernel.org> and let me know why this patch should be
> > > > applied.  Otherwise, it is now dropped from my patch queues, never to be
> > > > seen again.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > > ------------------ original commit in Linus's tree ------------------
> > > > 
> > > > >From b1f707146923335849fb70237eec27d4d1ae7d62 Mon Sep 17 00:00:00 2001
> > > > From: Arun Easi <aeasi@marvell.com>
> > > > Date: Tue, 12 Jul 2022 22:20:39 -0700
> > > > Subject: [PATCH] scsi: qla2xxx: Fix response queue handler reading stale
> > > >  packets
> > > > 
> > > > On some platforms, the current logic of relying on finding new packet
> > > > solely based on signature pattern can lead to driver reading stale
> > > > packets. Though this is a bug in those platforms, reduce such exposures by
> > > > limiting reading packets until the IN pointer.
> > > > 
> > > > Two module parameters are introduced:
> > > > 
> > > >   ql2xrspq_follow_inptr:
> > > > 
> > > >     When set, on newer adapters that has queue pointer shadowing, look for
> > > >     response packets only until response queue in pointer.
> > > > 
> > > >     When reset, response packets are read based on a signature pattern
> > > >     logic (old way).
> > > > 
> > > >   ql2xrspq_follow_inptr_legacy:
> > > > 
> > > >     Like ql2xrspq_follow_inptr, but for those adapters where there is no
> > > >     queue pointer shadowing.
> > > 
> > > On a meta-note, this patch seems VERY wrong.  You are adding a
> > > driver-wide module option for a device-specific action.  That should be
> > > a device-specific functionality, not a module.
> > > 
> > > Again, as I say many times, this isn't the 1990's, please never add new
> > > module parameters.  Use the other interfaces we have in the kernel to
> > > configure individual devices properly, module parameters are not to be
> > > used for that at all for anything new.
> > > 
> > > So, can you revert this commit and do it properly please?
> > > 
> > 
> > The reason I chose module parameter way was because of these primarily:
> > 
> > 1 As this is a platform specific issue, this behavior does not require a 
> >   device granular level tuning. Either all the said adapters turns the 
> >   behavior on or off.
> 
> What is going to allow a user to know to do this or not?  Why is this
> needed at all, and why doesn't the driver automatically know what to do
> either based on the device id, or the platform, or the workload?

The change is to err on the side of caution and make the logic 
a bit conservative at the same time providing an option for those 
platforms or architectures where the issue is not applicable, but the 
logic is causing a reduction in performance.

> 
> Forcing a user to pick something for "tuning" like this is horrible and
> messy and almost impossible to support properly over time.

The option is intended for slightly advanced users, platform or os 
vendors etc. When it comes to an end user, I agree it is challenging to 
know if a change from default is needed or not.

> Just do it in the driver automatically and then there's no need for any 
> options at all.

The platform bug exhibited as driver accessing stale memory, so it is 
tough to automatically tune the value automatically.

> 
> > 2 Module parameters allowed persistence without complexity: Since this 
> >   adapter is also used in booting on some environments, module parameter 
> >   allowed the configurability as well as simplicity.
> 
> Just because it is easy does not mean it is correct.  It is a
> device-specific option being applied to ALL devices in the system, which
> feels wrong.  If it is correct, then just do it automatically in the
> driver based on platform information.
> 
> > If the above approach is discouraged, the alternatives that comes to my 
> > mind are:
> > 
> > 1 Add a sysfs node 
> 
> Sure!
> 
> > 2 Add a debugfs node
> 
> Only if this really is only for debugging as that's what debugfs is for.
> You can never rely on debugfs to be present or accessable for anything
> that the system relies on for functionality.
> 
> > 3 /proc/sys/kernel ? (but that is not per adapter specific)
> 
> Ick, no.
> 
> > 4 Add a udev script to watch for PCI adapter addition and set/reset 1, 2 
> >   or 3
> 
> Your udev script will tie into the sysfs node.
> 
> > If udev route is taken, I'd have to come up with a configuration file to 
> > save tunable state, which could be a bit cumbersome and needs 
> > documentation and be different (in terms of script location/submitting) 
> > distro to distro.
> 
> How is a module parameter saving any state anywhere?

Since module parameter could be configured via modprobe.conf/equivalent, a 
user could set the value of his choice in that file and have the value 
persisted.

Regards,
-Arun

> Your sysfs rule should be identical to the rule that causes you to write 
> the module parameter file out to the device.
> 
> And then that logic, again, really should just be in the driver itself
> with no option needed at all.
> 
> Again, resist the option to force a user to do anything, that's messy
> and painful and not what a kernel should do if at all possible.
> 
