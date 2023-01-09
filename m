Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1E9661F27
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 08:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbjAIHXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 02:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbjAIHWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 02:22:55 -0500
Received: from mg.richtek.com (mg.richtek.com [220.130.44.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C6339596;
        Sun,  8 Jan 2023 23:22:50 -0800 (PST)
X-MailGates: (flag:4,DYNAMIC,BADHELO,RELAY,NOHOST:PASS)(compute_score:DE
        LIVER,40,3)
Received: from 192.168.10.47
        by mg.richtek.com with MailGates ESMTP Server V5.0(16481:0:AUTH_RELAY)
        (envelope-from <cy_huang@richtek.com>); Mon, 09 Jan 2023 15:22:27 +0800 (CST)
Received: from ex3.rt.l (192.168.10.46) by ex4.rt.l (192.168.10.47) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.20; Mon, 9 Jan
 2023 15:22:26 +0800
Received: from linuxcarl2.richtek.com (192.168.10.154) by ex3.rt.l
 (192.168.10.45) with Microsoft SMTP Server id 15.2.1118.20 via Frontend
 Transport; Mon, 9 Jan 2023 15:22:26 +0800
Date:   Mon, 9 Jan 2023 15:22:26 +0800
From:   ChiYuan Huang <cy_huang@richtek.com>
To:     ChiYuan Huang <u0084500@gmail.com>
CC:     Greg KH <gregkh@linuxfoundation.org>, <linux@roeck-us.net>,
        <heikki.krogerus@linux.intel.com>, <matthias.bgg@gmail.com>,
        <tommyyl.chen@mediatek.com>, <macpaul.lin@mediatek.com>,
        <gene_chen@richtek.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: typec: tcpm: Fix altmode re-registration causes
 sysfs create fail
Message-ID: <20230109072226.GA15975@linuxcarl2.richtek.com>
References: <1671096096-20307-1-git-send-email-u0084500@gmail.com>
 <Y5rsdo/SGHJM4UKG@kroah.com>
 <CADiBU3-iVLQf6Q5SzOB_pMCs2PGcFuWryjpDn5Qvz41WQ6C2RA@mail.gmail.com>
 <Y5sIZ3zC6o4ARDEn@kroah.com>
 <20230109014123.GA27423@linuxcarl2.richtek.com>
 <Y7u2Yi+UeqMcVhad@kroah.com>
 <CADiBU39yh9k=BWOmQ_-T3oO1nRQ6nHVjf4H+YRpjb3Mv_3tc0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADiBU39yh9k=BWOmQ_-T3oO1nRQ6nHVjf4H+YRpjb3Mv_3tc0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 09, 2023 at 02:46:34PM +0800, ChiYuan Huang wrote:
> Greg KH <gregkh@linuxfoundation.org> 於 2023年1月9日 週一 下午2:38寫道：
> >
> > On Mon, Jan 09, 2023 at 09:41:23AM +0800, ChiYuan Huang wrote:
> > > ************* Email Confidentiality Notice ********************
> > >
> > > The information contained in this e-mail message (including any attachments) may be confidential, proprietary, privileged, or otherwise exempt from disclosure under applicable laws. It is intended to be conveyed only to the designated recipient(s). Any use, dissemination, distribution, printing, retaining or copying of this e-mail (including its attachments) by unintended recipient(s) is strictly prohibited and may be unlawful. If you are not an intended recipient of this e-mail, or believe that you have received this e-mail in error, please notify the sender immediately (by replying to this e-mail), delete any and all copies of this e-mail (including any attachments) from your system, and do not disclose the content of this e-mail to any other person. Thank you!
> >
> > Now deleted.
> >
> > For obvious reasons, this wording is not compatible with kernel
> > development :(
> 
> I'm sorry about that. Let me check with MIS..............
This one seems work.

https://www.lkml.org/lkml/2023/1/9/73
