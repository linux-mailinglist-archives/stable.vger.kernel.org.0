Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C875EEE74
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 09:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiI2HHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 03:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234890AbiI2HHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 03:07:36 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FF318E3D;
        Thu, 29 Sep 2022 00:07:35 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1odndu-0003bE-3P; Thu, 29 Sep 2022 09:07:34 +0200
Message-ID: <828c7a9b-66b7-c936-a79a-91d43eaa4a9a@leemhuis.info>
Date:   Thu, 29 Sep 2022 09:07:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: linux-5.15.69 breaks nfs client #forregzbot
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <f6755107-b62c-a388-0ab5-0a6633bf9082@garloff.de>
 <d9a3460b-0ed6-4bfa-5bdd-032f4bc4ebce@leemhuis.info>
In-Reply-To: <d9a3460b-0ed6-4bfa-5bdd-032f4bc4ebce@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1664435255;184123c3;
X-HE-SMSGID: 1odndu-0003bE-3P
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

On 23.09.22 09:46, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker. CCing the regression
> mailing list, as it should be in the loop for all regressions, as
> explained here:
> https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html
> Also CCing the stable ml, the NFS maintainers, and the authors of
> 31b992b3c39b, too.
> 
> On 22.09.22 23:46, Kurt Garloff wrote:
>>
>> a freshly compiled 5.15.69 kernel showed hangs with NFS.
>> Typically mkdir would end up in a 'D' process state, but I
>> have seen ls -l hanging as well.
>> Server is kernel NFS 5.15.69.
>>
>> After reverting the last three NFS related commits,
>> a68a734b19af NFS: Fix WARN_ON due to unionization of nfs_inode.nrequests
>> 3b97deb4abf5 NFS: Fix another fsync() issue after a server reboot
>> 31b992b3c39b NFS: Save some space in the inode
>>
>> things work normally again.
>>
>> As you can see, I suspected 31b992b3c39b ...
> 
> FWIW, that's e591b298d7ec in mainline.
> 
>> I know this report is light on details; if nothing like this has been
>> reported yet, let me know and I'll try to find some time to investigate
>> further.
>>
>> PS: Please keep me on Cc, I'm not subscribed to linux-nfs.
> 
> [...]
> 
> #regzbot ^introduced 31b992b3c39b
> #regzbot ignore-activity

#regzbot fixed-by: 27bf7a5d11987
