Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328A35089C9
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 15:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiDTNvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 09:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379197AbiDTNv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 09:51:28 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3FD43499;
        Wed, 20 Apr 2022 06:48:42 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:54260)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nhAhE-009Qlq-HP; Wed, 20 Apr 2022 07:48:40 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:35004 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nhAhD-003KDU-L5; Wed, 20 Apr 2022 07:48:40 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        damien.lemoal@opensource.wdc.com, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Niklas.Cassel@wdc.com,
        lkp@intel.com, vapier@gentoo.org, gerg@linux-m68k.org,
        stable@vger.kernel.org
References: <20220418200834.1501454-1-Niklas.Cassel@wdc.com>
        <202204181501.D55C8D2A@keescook>
        <87mtgh17li.fsf_-_@email.froward.int.ebiederm.org>
        <165039039729.809958.17874221541968744613.b4-ty@chromium.org>
Date:   Wed, 20 Apr 2022 08:48:11 -0500
In-Reply-To: <165039039729.809958.17874221541968744613.b4-ty@chromium.org>
        (Kees Cook's message of "Tue, 19 Apr 2022 10:46:40 -0700")
Message-ID: <87h76n27dw.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nhAhD-003KDU-L5;;;mid=<87h76n27dw.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX18FFPP0YfysqT9KZNiOyZqfSkTypL/ShzA=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 273 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 3.8 (1.4%), b_tie_ro: 2.6 (1.0%), parse: 1.02
        (0.4%), extract_message_metadata: 11 (4.0%), get_uri_detail_list: 0.73
        (0.3%), tests_pri_-1000: 12 (4.5%), tests_pri_-950: 1.06 (0.4%),
        tests_pri_-900: 0.85 (0.3%), tests_pri_-90: 90 (32.8%), check_bayes:
        87 (31.8%), b_tokenize: 6 (2.2%), b_tok_get_all: 5 (1.9%),
        b_comp_prob: 1.92 (0.7%), b_tok_touch_all: 71 (25.9%), b_finish: 0.75
        (0.3%), tests_pri_0: 142 (51.9%), check_dkim_signature: 0.37 (0.1%),
        check_dkim_adsp: 2.3 (0.8%), poll_dns_idle: 0.65 (0.2%), tests_pri_10:
        1.68 (0.6%), tests_pri_500: 7 (2.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: (subset) [PATCH] binfmt_flat; Drop vestigates of coredump support
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Tue, 19 Apr 2022 09:16:41 -0500, Eric W. Biederman wrote:
>> There is the briefest start of coredump support in binfmt_flat.  It is
>> actually a pain to maintain as binfmt_flat is not built on most
>> architectures so it is easy to overlook.
>> 
>> Since the support does not do anything remove it.
>> 
>> 
>> [...]
>
> Applied to for-next/execve, thanks! (With typo nits fixed.)
>
> [1/1] binfmt_flat; Drop vestigates of coredump support
>       https://git.kernel.org/kees/c/6e1a873cefd1

Thanks,
Eric

