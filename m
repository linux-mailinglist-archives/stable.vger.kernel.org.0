Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F91661C08
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 02:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjAIBlw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 8 Jan 2023 20:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjAIBlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Jan 2023 20:41:51 -0500
X-Greylist: delayed 389 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 08 Jan 2023 17:41:49 PST
Received: from mg.richtek.com (mg.richtek.com [220.130.44.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 951A5DC3;
        Sun,  8 Jan 2023 17:41:47 -0800 (PST)
X-MailGates: (flag:4,DYNAMIC,BADHELO,RELAY,NOHOST:PASS)(compute_score:DE
        LIVER,40,3)
Received: from 192.168.10.46
        by mg.richtek.com with MailGates ESMTP Server V5.0(16491:0:AUTH_RELAY)
        (envelope-from <cy_huang@richtek.com>); Mon, 09 Jan 2023 09:41:24 +0800 (CST)
Received: from ex3.rt.l (192.168.10.46) by ex3.rt.l (192.168.10.46) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.20; Mon, 9 Jan
 2023 09:41:23 +0800
Received: from linuxcarl2.richtek.com (192.168.10.154) by ex3.rt.l
 (192.168.10.45) with Microsoft SMTP Server id 15.2.1118.20 via Frontend
 Transport; Mon, 9 Jan 2023 09:41:23 +0800
Date:   Mon, 9 Jan 2023 09:41:23 +0800
From:   ChiYuan Huang <cy_huang@richtek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     ChiYuan Huang <u0084500@gmail.com>, <linux@roeck-us.net>,
        <heikki.krogerus@linux.intel.com>, <matthias.bgg@gmail.com>,
        <tommyyl.chen@mediatek.com>, <macpaul.lin@mediatek.com>,
        <gene_chen@richtek.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: typec: tcpm: Fix altmode re-registration causes
 sysfs create fail
Message-ID: <20230109014123.GA27423@linuxcarl2.richtek.com>
References: <1671096096-20307-1-git-send-email-u0084500@gmail.com>
 <Y5rsdo/SGHJM4UKG@kroah.com>
 <CADiBU3-iVLQf6Q5SzOB_pMCs2PGcFuWryjpDn5Qvz41WQ6C2RA@mail.gmail.com>
 <Y5sIZ3zC6o4ARDEn@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <Y5sIZ3zC6o4ARDEn@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 12:43:35PM +0100, Greg KH wrote:
> On Thu, Dec 15, 2022 at 05:53:44PM +0800, ChiYuan Huang wrote:
> > Greg KH <gregkh@linuxfoundation.org> 於 2022年12月15日 週四 下午5:44寫道：
> > >
> > > On Thu, Dec 15, 2022 at 05:21:36PM +0800, cy_huang wrote:
> > > > From: ChiYuan Huang <cy_huang@richtek.com>
> > >
> > > Why not send directly from this address so we can validate that this is
> > > the correct email address of yours?
> > >
> > It's  the company mailbox policy. To send the external mail, there's
> > the security text block at the bottom.
> > Except this, some mail address are also blocked. To avoid this, I use
> > my personal mail to send the patch
> > and leave the SoB for the Richtek mailbox.
> > It's lazy to fight for this.
>
> Please fix it, otherwise your company's email address will be spoofed
> and people can claim to be sending changes from their domain.
>
> Please fix that up, abusing random gmail addresses like this is not ok,
> sorry.

Thanks for your comment.
After the work with MIS for several weeks, we finnaly got one way to do it.

But I'm not sure all mail account can receive the mail.
If anyone cannot receive the mail, please inform me.

ChiYuan Huang.

>
> greg k-h
************* Email Confidentiality Notice ********************

The information contained in this e-mail message (including any attachments) may be confidential, proprietary, privileged, or otherwise exempt from disclosure under applicable laws. It is intended to be conveyed only to the designated recipient(s). Any use, dissemination, distribution, printing, retaining or copying of this e-mail (including its attachments) by unintended recipient(s) is strictly prohibited and may be unlawful. If you are not an intended recipient of this e-mail, or believe that you have received this e-mail in error, please notify the sender immediately (by replying to this e-mail), delete any and all copies of this e-mail (including any attachments) from your system, and do not disclose the content of this e-mail to any other person. Thank you!
