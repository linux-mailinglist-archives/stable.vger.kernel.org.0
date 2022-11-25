Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF69638CD3
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 16:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiKYPAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 10:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiKYPAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 10:00:05 -0500
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6707827B0C
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 07:00:03 -0800 (PST)
Received: from in02.mta.xmission.com ([166.70.13.52]:43308)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <dominic@xmission.com>)
        id 1oyaBO-009y0J-CA; Fri, 25 Nov 2022 08:00:02 -0700
Received: from 75-169-132-183.slkc.qwest.net ([75.169.132.183]:43626 helo=mail.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <dominic@xmission.com>)
        id 1oyaBN-00HFGF-Ei; Fri, 25 Nov 2022 08:00:02 -0700
Date:   Fri, 25 Nov 2022 14:59:54 +0000
Message-ID: <8879f97bc9fcf2c540e64bc282a6f808.dominic@xmission.com>
From:   Dominic Jones <jonesd@xmission.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain
X-XM-SPF: eid=1oyaBN-00HFGF-Ei;;;mid=<8879f97bc9fcf2c540e64bc282a6f808.dominic@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=75.169.132.183;;;frm=dominic@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX1/SsQ0FRfcvrDgx2p6GRJ9r
X-SA-Exim-Connect-IP: 75.169.132.183
X-SA-Exim-Mail-From: dominic@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Thorsten Leemhuis <regressions@leemhuis.info>
X-Spam-Relay-Country: 
X-Spam-Timing: total 373 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 11 (2.9%), b_tie_ro: 10 (2.6%), parse: 0.64
        (0.2%), extract_message_metadata: 3.2 (0.8%), get_uri_detail_list:
        1.33 (0.4%), tests_pri_-1000: 4.1 (1.1%), tests_pri_-950: 1.24 (0.3%),
        tests_pri_-900: 0.97 (0.3%), tests_pri_-200: 0.82 (0.2%),
        tests_pri_-100: 8 (2.0%), tests_pri_-90: 98 (26.3%), check_bayes: 94
        (25.3%), b_tokenize: 5 (1.4%), b_tok_get_all: 6 (1.7%), b_comp_prob:
        2.4 (0.6%), b_tok_touch_all: 76 (20.5%), b_finish: 0.99 (0.3%),
        tests_pri_0: 206 (55.2%), check_dkim_signature: 0.44 (0.1%),
        check_dkim_adsp: 2.7 (0.7%), poll_dns_idle: 20 (5.4%), tests_pri_10:
        2.3 (0.6%), tests_pri_500: 30 (7.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [REGRESSION] v6.0.x fails to boot after updating from v5.19.x
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> 
> On 24.11.22 02:08, Dominic Jones wrote:
> >> On Fri, Oct 28, 2022 at 02:51:43PM +0000, Dominic Jones wrote:
> >>> Updating the machine's kernel from v5.19.x to v6.0.x causes the machine to not
> >>> successfully boot. The machine boots successfully (and exhibits stable operation)
> >>> with version v5.19.17 and multiple earlier releases in the 5.19 line. Multiple releases
> >>> from the 6.0 line (including 6.0.0, 6.0.3, and 6.0.5), with no other changes to the
> >>> software environment, do not boot. Instead, the machine hangs after loading services
> >>> but before presenting a display manager; the machine instead shows repetitive hard
> >>> drive activity at this point and then no apparent activity.
> >>>
> >>> ''uname'' output for the machine successfully running v5.19.17 is:
> >>>
> >>>     Linux [MACHINE_NAME] 5.19.17 #1 SMP PREEMPT_DYNAMIC Mon Oct 24 13:32:29 2022 i686 Intel(R) Atom(TM) CPU N270 @ 1.60GHz GenuineIntel GNU/Linux
> >>>
> >>> The machine is an OCZ Neutrino netbook, running a custom OS build largely similar to
> >>> LFS development. The kernel update uses ''make olddefconfig''.
> >>
> >> Can you use 'git bisect' to find the offending change that causes this
> >> to happen?
> > 
> > Bisection is complete. Here's what it returned.
> > 
> > ---
> > 
> > 3a194f3f8ad01bce00bd7174aaba1563bcc827eb is the first bad commit
> 
> Many thx for this. A fix for that particular commit for recently
> committed to 6.0.y:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.0.y&id=bccc10be65e365ba8a3215cb702e6f57177eea07
> 
> That thus bears the question: does your problem still happen with the
> latest 6.0.y version?

I'll test; it looks like 6.0.9 is the current stable release so I'll give that a
try.


Dominic
