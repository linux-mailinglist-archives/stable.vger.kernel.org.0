Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E1162FDFD
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 20:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbiKRT2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 14:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241103AbiKRT2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 14:28:14 -0500
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9014D73BB4
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 11:28:08 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:41930)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <dominic@xmission.com>)
        id 1ow71z-00GjYH-J5; Fri, 18 Nov 2022 12:28:07 -0700
Received: from 75-169-132-183.slkc.qwest.net ([75.169.132.183]:33748 helo=mail.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <dominic@xmission.com>)
        id 1ow71y-001VPa-JZ; Fri, 18 Nov 2022 12:28:07 -0700
Date:   Fri, 18 Nov 2022 19:25:05 +0000
Message-ID: <1c69774a5721e5d916791f545666b7da.dominic@xmission.com>
From:   Dominic Jones <jonesd@xmission.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain
X-XM-SPF: eid=1ow71y-001VPa-JZ;;;mid=<1c69774a5721e5d916791f545666b7da.dominic@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=75.169.132.183;;;frm=dominic@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX1+gg0LTinpTWiKVBhJebXrf
X-SA-Exim-Connect-IP: 75.169.132.183
X-SA-Exim-Mail-From: dominic@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 484 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 11 (2.3%), b_tie_ro: 9 (2.0%), parse: 1.14 (0.2%),
         extract_message_metadata: 19 (3.9%), get_uri_detail_list: 1.90 (0.4%),
         tests_pri_-1000: 22 (4.5%), tests_pri_-950: 1.79 (0.4%),
        tests_pri_-900: 1.32 (0.3%), tests_pri_-200: 1.07 (0.2%),
        tests_pri_-100: 10 (2.0%), tests_pri_-90: 197 (40.8%), check_bayes:
        195 (40.3%), b_tokenize: 7 (1.4%), b_tok_get_all: 6 (1.3%),
        b_comp_prob: 2.9 (0.6%), b_tok_touch_all: 175 (36.1%), b_finish: 1.22
        (0.3%), tests_pri_0: 201 (41.6%), check_dkim_signature: 0.64 (0.1%),
        check_dkim_adsp: 3.5 (0.7%), poll_dns_idle: 0.76 (0.2%), tests_pri_10:
        2.8 (0.6%), tests_pri_500: 11 (2.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [REGRESSION] v6.0.x fails to boot after updating from v5.19.x
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Fri, Oct 28, 2022 at 02:51:43PM +0000, Dominic Jones wrote:
> > Updating the machine's kernel from v5.19.x to v6.0.x causes the machine to not
> > successfully boot. The machine boots successfully (and exhibits stable operation)
> > with version v5.19.17 and multiple earlier releases in the 5.19 line. Multiple releases
> > from the 6.0 line (including 6.0.0, 6.0.3, and 6.0.5), with no other changes to the
> > software environment, do not boot. Instead, the machine hangs after loading services
> > but before presenting a display manager; the machine instead shows repetitive hard
> > drive activity at this point and then no apparent activity.
> > 
> > ''uname'' output for the machine successfully running v5.19.17 is:
> > 
> >     Linux [MACHINE_NAME] 5.19.17 #1 SMP PREEMPT_DYNAMIC Mon Oct 24 13:32:29 2022 i686 Intel(R) Atom(TM) CPU N270 @ 1.60GHz GenuineIntel GNU/Linux
> > 
> > The machine is an OCZ Neutrino netbook, running a custom OS build largely similar to
> > LFS development. The kernel update uses ''make olddefconfig''.
> 
> Can you use 'git bisect' to find the offending change that causes this
> to happen?

Wanted to follow up here. I got up to speed on ''git bisect'' and am currently
running the process. It looks like I have about six iterations to go and I'm
typically building/testing 1-3 kernels per day. I can also verify that the issue
occurs under 6.1rc4 as a side effect of the process.


Dominic Jones
jonesd@xmission.com
