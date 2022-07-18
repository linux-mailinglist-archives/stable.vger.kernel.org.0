Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F645780C3
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 13:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbiGRLbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 07:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiGRLbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 07:31:43 -0400
Received: from sonic305-19.consmr.mail.gq1.yahoo.com (sonic305-19.consmr.mail.gq1.yahoo.com [98.137.64.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFEC1A80B
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 04:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1658143901; bh=vU3ZLqrkSQIaJtC6Zr4tW2XgNY1XaXjXDHRa4si9P9Y=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=oPYNapj14JGsOS7fJFGjI+LrA5nNdtYn9td8zrCbJYSEM7TcVdxtJ/T1OCjWwgJC/5e5UVr9pYmQnbgnrkMQKF0z/y8T5cfHdrHG7lTJQCyIibosYrpGmiLiNv6QCpgqE9vb6jxUAN3iCnbzX1RdVHINPx2GVJBmVg/UXprpqf+JN9KNdn7BkXP9iZ4kEjvMnLV3MBgo14vfTRjnfn5hmfIdSwh5PDtAveYr6FXOQREts6/cYsNTlAlQEFdU0bqkbgJ3L6UhIRrN6gJemBPJnTpvsgLT3Q6ZISDSRsh7Ho0PolX2GoZYMCUJ+iDhTDRbNzUGU2jfRhxivbCQA4gwsw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1658143901; bh=wwUT/2GVX9bgSP9JuL8dtb1HFyBJuTI3goTr/Edxfai=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=s71RGujzCiw2tODvXD/dVyDC7f/sqmsmHT4wIHAzxWUHncxVOZvspfoMoBBdObNQgwajcdfof2BYqO5VXTf8MFLdiP4sSxHsWotMyJZ+KMrDjkmkrM6jkN/6rMdrB+gF5WQJdUCYtHO/8F6mH5A89Q9DKhAkOmuOD+/T0VL2ZniGhhLkyf6YvDN/baYfkSkPMSmplkbfD2gVMT+3Q5YFURs5FBycKDPfE/Sc8rtHKuthcuPo+l7nqqLQBuoYwZPehCY3Od+xvVsS4JyQIoWlTo5f+DqYaNx8ofar88HOUyQim2iw7ibRY91dgyu3kZzCAJxeJbzvvYU2zVG0MQNfiQ==
X-YMail-OSG: fHo10v8VM1nZLCPyFeGtx9WXzqf5ZY2n9GOP9e9q3ThLL78RO8XSSpXsabO2wJ0
 Sycro7ZYBa5ROubecEAAiPDOV5XlfLhouQ5xi0NDzhj18HpT8NLRM83j8kRY3nHwZa87sN7nAmGm
 quvd_2GgEcDugPHGszX65Q7Cqpz_zATGtf.idGv3ekmWkWE5.wsFhkIpPACMY5K3CijVctehJxWS
 NH6Gt3uD7GBKtQoXedttQ5n4VRDCo7vZPwIYznn_kkWikFU2ka.RSqAwLxzN.ZCXhLkUIFb4GWa6
 zKWJ26a7MeNkGkzzxRTtLvwquwDnVF2b88cTlPIeyymIbfbU.NttN46kcopVmdrv_yUklxj85bgg
 7RTXwUGk8rdy2mpSNmYsXfWKGhs02.ku7sGKVreupxcRqyWuv5Oft90e0yE_yL3wcLpWB2AFhA_Q
 bKeA8LdZ1ybvkvl2dl_m7W7JDsbBuoqaJ0x.SLh6wZQxvI8MHQj9tRQ1gwelN7ARoHdTtZrSkiq2
 resMfogYX0v6k4E8zisERd8CE1ZP5MgQ81Rslxd5v9agw9EES_I2Na7o44JsogYhWcz.XSdHM3Oi
 2o13081lT9d6lGxomhGjmVUFGXlPkf1zMMtLnAhbxByNyLlL3PrjkaUzUi86afQk3tdXy.GWjWRQ
 wGCDZZI.r4y6ZmUzG.n3HJTE0VUcljuk7YAHRAIb.Ru9umKJ_H2hTVOaFDwCyUZnfCN5IDqz.jtZ
 WFE8v2IV1dWusKaBRi6o_vbl65SY8Kk4kkK4ZGY1cx.XGPQxbllJuk4ZClyw_nKQfcK7TISZguLs
 27WIL6duyfnUG9tCRtjVOkgG6Rpvtp40FYn8y6M32FwkSUVQkpiYIxoSwNxhsPwbiP1sRYKESj.8
 bCrYLmj3z.RMGpg3d4d8iZqKZ9L81q7A06tx8Yq80qCLsMUPUpQnSxPrzgoIjABN1wMLtj7HVA5n
 ml8XHBMWG3nFBc4OgFKj0N_.3rOOtdMe0ddTM7vKzJxsuNY1sncaYUFgdtSjOO2y_vnj3jKSryNc
 POt384.0zPfCT6pqQ6ByQGJgci53jMzY0ces0WABSJAnTU9f03bKmXYrQS0eY6uU_b6WmqCu2.O6
 zvjiMjMIFecmN5HGfxVaoMs.79LEq28Ak6LT5JcjQowFDqtbM4J7i0hqhgXgsMZkS_4_eVI7zCeA
 hkiSdVwJzWlNVGb6DWvWOWCdsJlhjrZ8coyFJniLpLfk12Z2tlZ_4xplCODdt77lDRDFanEP5mTl
 k6d9pQjdDJO9YMCkp0xlyjMvWX8dtlmNhEymB7MIKxwCUfG8sKFeP4O6iNplkW0x2UQXdSNaSfli
 wO0FyLdfHfEO_ovQYnOWInXOToJvISFSHzUB0nJ39Svty6f0unawJsY0bxxPj13uQ3pqL1KZrCS3
 QZeR.EBjbB6p6q_7dQHvVxlNZulMcBxVYAAlCYMNsTXW0NoI4MSobXk0cBFLQdLVFjFj5omygw.P
 VXubNv7gXd6h89aKro34_miJaBqP.R27IFsyfi.OS4iu5sQWMJpPpDoEcM4myiueEkrbH6oMBIkG
 0ezBUbV9AFV6UOi3YJGHebtcSbQsN_P8b1Tn7APr6wSveVKsKLcoqnmA2YyVpG3CusMS0TZPE_4J
 mIbupF8W4cm97b5Z1vVUrkJ.uiAKrVcfGOd4oYSdghKM1oVYPsWe5.scEbHX.wHnwt2P6ZVkg8Ix
 iRJGKSU51GqIBTZAiIWj3V8sUzecqPZAEtusTHlHoCwM87jS2BQb7cet03bP5GeAhdqeP.amD8ih
 MnMZApqzKngK3JXKkSXDdCOIjgRiI4jCff3G3X0EtU1GAewmeCkgo5jyJeT7I_tIPNmDXv16fN6B
 sNbGEppApl0eJCIUT3q0b5Oe25InsXAnxsAzYvcg7eMUWklpkUFCQAimiqJ90LMkpGY99LJSqQ38
 inmkB0FG5EBNf.wNCBN.ReK.yXUbsvaRfg1XJd0WxFWRNgbte
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.gq1.yahoo.com with HTTP; Mon, 18 Jul 2022 11:31:41 +0000
Received: by hermes--production-ne1-7864dcfd54-gln7g (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 6f21bd833f494b9154abcf7d0f4e6dd9;
          Mon, 18 Jul 2022 11:31:39 +0000 (UTC)
Message-ID: <8eb62e12-17cf-cce6-666a-8ebb7915f461@netscape.net>
Date:   Mon, 18 Jul 2022 07:31:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>, Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        linux-kernel@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <5ea45b0d-32b5-1a13-de86-9988144c0dbe@leemhuis.info>
 <56a6ab5f-06fb-fa11-5966-cb23cb276fa6@netscape.net>
 <d3555a74-d0cb-ca73-eb2e-082f882b5c81@suse.com>
 <1309c3f5-86c7-e4f8-9f35-e0d430951d49@netscape.net>
 <764ea65f-269a-6f32-c780-cbdd7cf09120@suse.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <764ea65f-269a-6f32-c780-cbdd7cf09120@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/18/2022 2:07 AM, Jan Beulich wrote:
> On 15.07.2022 21:53, Chuck Zmudzinski wrote:
> > Two things I see here in my efforts to get a patch to fix this regression:
> > 
> > 1. Does Xen have plans to give Linux running in Dom0 write-access to the
> > PAT MSR?
>
> No, as this is not technically feasible (all physical CPUs should run
> with the same value in the MSR, or else other issues arise).
>
> > 2. Does Xen have plans to expose MTRRs to Linux running in Dom0?
>
> Yen does expose MTRRs to PV Dom0, but via a hypercall mechanism. I
> don't think there are plans on the Xen side to support the MSR
> interface (and hence to expose the CPUID bit), and iirc there are
> no plans on the Linux side to use the MTRR interface. This also
> wouldn't really make sense anymore now that it has become quite
> clear that Linux wants to have PAT working without depending on
> MTRR.

I am not so sure about that, given what Borislav Petkov
said when commenting on your patch here:

https://lore.kernel.org/lkml/YsRjX%2FU1XN8rq+8u@zn.tnic/

Specifically, Borislav Petkov wrote on Tue, 5 Jul 2022 18:14:23 +0200:

Actually, the current goal is to adjust Xen dom0 because:

1. it uses the PAT code

2. but then it does something special and hides the MTRRs

which is not something real hardware does.

So this one-off thing should be prominent, visible and not get in the
way.

--------------end of Borislav Petkov quote-----------

Jan, can you explain this comment by Borislav Petkov about
Xen being a "one-off thing" that hides MTRRs and needs
to be "adjusted" so it does "not get in the way"?

Borislav, are you willing to retract the comments you made
on Tue, 5 Jul 2022 18:14:23 +0200 about Xen?

>
> Jan

Jan, thanks for answering my questions.

Chuck
