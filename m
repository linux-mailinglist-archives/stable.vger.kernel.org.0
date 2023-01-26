Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766FF67D347
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 18:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjAZRfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 12:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjAZRez (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 12:34:55 -0500
X-Greylist: delayed 2094 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 Jan 2023 09:34:54 PST
Received: from bosmailout08.eigbox.net (bosmailout08.eigbox.net [66.96.186.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C5E134
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 09:34:54 -0800 (PST)
Received: from [10.20.15.1] (helo=bosmailscan01.eigbox.net)
        by bosmailout08.eigbox.net with esmtp (Exim)
        id 1pL5bS-0005Tk-Vz
        for stable@vger.kernel.org; Thu, 26 Jan 2023 11:59:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bestfzyhs.com; s=dkim; h=Sender:Content-Transfer-Encoding:Content-Type:
        Message-ID:Reply-To:Subject:To:From:Date:MIME-Version:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=X2ynI9Fsuf73Q/abz5DQqXyVbIcRJ5o0sL15Wzf8gr0=; b=Qa8b+LVf5iJqev3RDJAPfiP2jM
        42avjbcsbTun2bSSheAIW4dyI2Lme6eRjFNXBQcsQLkeiYkgCAZGHfMl3Ws8ZAuUp0bQN7NvXg3Qk
        z9T5obaYA6hTEV2kWwQuhvYZGlQiL0ZDPoga1ui4CjxRZkbuGZlI7N8iY1nIkXkrmJltfvTggAKyy
        E1LziACAoqh+pE0rPqd9az+IcfwZK9fNRiprR57rSXFsX59b91JmQdItb65sG9VswDsYKaLv6YI5B
        fKIOwxPhvMyruZrG8Ufb3RpI+M9HxWDsh0zuNudmXDmrK62Dckutb+pf9pjA0hs5RtH16Id8WNpVG
        +qisNSIg==;
Received: from [10.115.3.32] (helo=bosimpout12)
        by bosmailscan01.eigbox.net with esmtp (Exim)
        id 1pL5bR-0005Dq-Gj; Thu, 26 Jan 2023 11:59:57 -0500
Received: from boswebmail01.eigbox.net ([10.20.16.1])
        by bosimpout12 with 
        id DUzt2900D01NZ2201UzwKH; Thu, 26 Jan 2023 11:59:57 -0500
X-EN-SP-DIR: OUT
X-EN-SP-SQ: 1
Received: from [127.0.0.1] (helo=homestead)
        by boswebmail01.eigbox.net with esmtp (Exim)
        id 1pL5bP-0006HO-SF; Thu, 26 Jan 2023 11:59:55 -0500
Received: from [197.239.81.60]
 by emailmg.homestead.com
 with HTTP (HTTP/1.1 POST); Thu, 26 Jan 2023 11:59:55 -0500
MIME-Version: 1.0
Date:   Thu, 26 Jan 2023 08:59:55 -0800
From:   Mrs Lorence Gonzalez <mrs.lorence@bestfzyhs.com>
To:     undisclosed-recipients:;
Subject: Hello
Reply-To: mrslorencegonzalez@gmail.com
Mail-Reply-To: mrslorencegonzalez@gmail.com
Message-ID: <b1149e519bccea7ce5e778debe516588@bestfzyhs.com>
X-Sender: mrs.lorence@bestfzyhs.com
User-Agent: Roundcube Webmail/1.3.14
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-EN-AuthUser: mrs.lorence@bestfzyhs.com
Sender:  Mrs Lorence Gonzalez <mrs.lorence@bestfzyhs.com>
X-Spam-Status: Yes, score=7.3 required=5.0 tests=BAYES_50,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_REPLYTO,FROM_FMBLA_NEWDOM,
        HEADER_FROM_DIFFERENT_DOMAINS,ODD_FREEM_REPTO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_MR_MRS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [66.96.186.8 listed in list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5303]
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [66.96.186.8 listed in wl.mailspike.net]
        *  0.2 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level
        *      mail domains are different
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.9 ODD_FREEM_REPTO Has unusual reply-to header
        *  0.0 T_HK_NAME_MR_MRS No description available.
        *  0.1 DKIM_INVALID DKIM or DK signature exists, but is not valid
        *  1.0 FROM_FMBLA_NEWDOM From domain was registered in last 7 days
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hello,

Am a dying woman here in the hospital, i was diagnose as a Cancer
patient over  2 Years ago. I am A business woman how dealing with Gold
Exportation. I Am from Us California
I have a charitable and unfulfilled project that am about to handover
to you, if you are interested please reply

Hope to hear from you.
Regard

mrslorencegonzalez@gmail.com

Mrs.lorence Gonzalez





