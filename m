Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8281545BA0
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 07:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiFJFXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 01:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbiFJFXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 01:23:07 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Jun 2022 22:23:04 PDT
Received: from smtp687out9.mel.oss-core.net (smtp687out9.mel.oss-core.net [210.50.216.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B5FB1F37AA
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 22:23:04 -0700 (PDT)
X-IPAS-Result: =?us-ascii?q?A2DQUABh1KJi/2o43G9aGgEBAQEBDS8BAQEBAgIBAQEBA?=
 =?us-ascii?q?gEBAQEDAQEBAQELCQmBSIE6AgGkQ4cZG4IliWMLAQEBITAEAQGEeAEBWQWEc?=
 =?us-ascii?q?yY4EwECBAEBAQEDAgMBAQEBAQEDAQEGAQEBAQEBBgSBHIUvRoZUIAcBgVYBD?=
 =?us-ascii?q?gEehXYBATGsHYEzDXSEWRSCEAQKgnOBOwIBAQGJSoVgfYEQhBABhX2DQIIuB?=
 =?us-ascii?q?JI6hUEEGzoDHxUTNBKBIUUsAQgGBgcKBTIGAgwYFAQCExJTHQISDAocDlQZD?=
 =?us-ascii?q?A8DEgMRAQcCCxIIFSwIAwIDCAMCAy4CAxcJBwoDHQgKChISEBQCBAYNHgsIA?=
 =?us-ascii?q?xkfLAkCBA4DRQgLCgMRBAMTGAsWCBAEBgMJLw0oCwMUDwEGAwYCBQUBAyADF?=
 =?us-ascii?q?AMFJwcDIQcLJg0NBCMdAwMFJgMCAhsHAgIDAgYXBgICbwomDQgECAQMEB0kE?=
 =?us-ascii?q?AUCBzEFBC8CHgQFBhEJAhYCBgQFAgQEFgICEggCCCcbBxY2GQEFDk8GCwkhH?=
 =?us-ascii?q?AkgEQUGFgMjcQVIDyk1NjwQHyEcCiwGfA+dIJJIkEOeNgqDTgUpB4EKB55MM?=
 =?us-ascii?q?YNjAZcTEQEngVeLVJZqqBKBGYF+cBWCCIEcUCidEIEQAgYLAQEDCY5cAQE?=
IronPort-Data: A9a23:0MniMKAVB4ExUhVW/6vhw5YqxClBgxIJ4kV8jS/XYbTApGgkgTIAx
 jcXUW6EPPyNMzD2c913O4ri8BgPvsLXmtI3OVdlrnsFo1Bi95OZWYzxwmQcns+2BpeeJK6yx
 5xGMrEsFC2wJ5Pljk/F3oLJ9BGQ7onVAOulYAL4EnopH1U8Fn550UsLd9MR2+aEv/DoW2thh
 vuqyyHvEAfNN+lcaz98Bwqr8XuDjdyq0N8qlgVWicNj4Dcyo0Io4Kc3fsldGZdXrr58RYZWT
 86bpF2wE/iwEx0FUrtJmZ6jGqEGryK70QWm0hJrt6aebhdqmDcsi/oQNuQlWGh5iyqWz95Ny
 pJBjMnlIespFvWkdOU1bDh+VgMhEoNq0pbgfCGd2SCR5xSfKj22ma0oUR9wZNVGkgp0KTgmG
 fgwKTYDaTiGjuS60fSwTewEasELfJO3Z9hG4SwIITfxP/IoY7yZW4rz2+QE2jc8iPFyNNria
 J9MAdZoRFGaC/FVAX8MFJs0mOqAmHbyaXtbpUiTqK5x5HLcpDGdy5C0aYOQIIbSAJgL2x/A+
 CTd422/HRsAM9WTwzOD/jSqi/OJlD6TtJ8uKYBUP8VC2DW7rlH/wjVPPbdniZFVUnKDZu8=
IronPort-HdrOrdr: A9a23:GIMj/KGCQ/jZWZD0pLqEi8eALOsnbusQ8zAXPidKJiC9E/b1qy
 nAppUmPHPP4wr5JktBpTnoAsDpfZq7z/BICOIqV4tKMjOKhFeV
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.91,288,1647262800"; 
   d="scan'208";a="82433135"
Received: from 111-220-56-106.sta.wbroadband.net.au (HELO WIN-J7GFDBAO51J) ([111.220.56.106])
  by smtp687.mel.oss-core.net with ESMTP; 10 Jun 2022 15:21:57 +1000
From:   "Perry Davidson" <info@mandy.com>
Subject: Acknowledge this message
To:     <stable@vger.kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Reply-To: <pd1086787@gmail.com>
Date:   Thu, 9 Jun 2022 22:21:57 -0700
Message-Id: <202209062221569CBCA39DA1$0AB08CB367@mandy.com>
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_LOW,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.7 RCVD_IN_DNSWL_LOW RBL: Sender listed at https://www.dnswl.org/,
        *       low trust
        *      [210.50.216.236 listed in list.dnswl.org]
        *  3.3 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [111.220.56.106 listed in zen.spamhaus.org]
        *  1.3 RCVD_IN_BL_SPAMCOP_NET RBL: Received via a relay in
        *      bl.spamcop.net
        *      [Blocked - see <https://www.spamcop.net/bl.shtml?111.220.56.106>]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 SPF_SOFTFAIL SPF: sender does not match SPF record (softfail)
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [pd1086787[at]gmail.com]
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I will send you more details as soon as you acknowledge this message.
Thank you.
Perry Davidson.

