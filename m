Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1DB5780C8
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 13:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiGRLca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 07:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbiGRLc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 07:32:29 -0400
Received: from sonic309-20.consmr.mail.gq1.yahoo.com (sonic309-20.consmr.mail.gq1.yahoo.com [98.137.65.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939791FCF7
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 04:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1658143948; bh=vrfJ9pyqjWpK7xL7Agn/Qyz9mLq/DkPBwszWxndRwkw=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=aVUgLDjdoRtoM7Su17+uh5Ph70eJ5A6NzAQV7WqnaRkupPA/5sqR7lYZ/GfTfwH3QSVNmD02omwxJ95VjQM/gSw9RmvzzqMVTWlBl0X2yPE9SpnB36O3KeyHj7SUovJbUEqUELNCYfFSkWXOSoGNzZUl/iPntFLpVVJJplwjW51eM8GVjmOuQ1CDluZ89+3963i0W7MDrCsxlz8iiVIz9HLg++fI05KFgYWHjxe9z9GSBWMCUfTbX0FEUoDv+5lWznNnAibShLyPLxp7jOX4rdua8fbwVf0Ftx4v5UIYNyF9JBpow0kchR5TO/vmJKD29DA8SdIlPz9Nf5qCvGyLwQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1658143948; bh=pLWoEJP5gyWDQwvGvWcwstoh/8L5KauqGMcTiDSVn+m=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=XZZVVlT1aR25OfUfsDS9DnhEPzfZvtCkLnoj5GMGNvwv3517Ke8byGe//up3U8OEW7mn4OD6tmgaL5Jqs6eDh2A0r26+MA0YcKso2ywJeDQKbwvkBW2DHrb418VDnTq+Oj7SSOY3khfHR3v0iodl8cuxQEfUzPDtyMXjJ4AWQpXkYVID3C0LpdUpanvxvhQu6rhWaIkvFuKtGAbwTGREP5q8ohKy+4+zOpDxjwHc7zw69J+23+mYjX7GXq/A4qjRkBzuIGKSuHqeFQQlv6+33C0At0+ouTfBfBLAMtPha+gADX9s3/+AZ3SI/wKEFmFaHcJ+AVEcJ++dCxw7D0vrcQ==
X-YMail-OSG: iPgMkIIVM1m_mM.C9E6stDxh6XaPikarGZGOdGjWjq355k9cvwWaGxdt3TVgK0k
 XOhv56ChvgvZ.8Sjtz.fBlqqScrYXUuo10KIDFycg8H39F.opllfBgwDTMnVwf0gRjE5zMcrMz6j
 2PfVHi.zhWOkVapgmW1nqpVgv4rRxCqszb7hfcI1TsMaM_v.cex47uLa4Aj8nmGX8wrzndDkyHWl
 AWuT1uJRuXnu8ovfCEAwwD7_1f6_CO0fab7sqUYv8rCESr_7sy_KQS7D3HoIR.3VqmnhxavFfVYl
 GmMmkh2FH_5iqZxQHGGFePg9zPnxiK2rFF5Ha7MGv1e3AjncpknD8XIFcvAv7hDcnMYuUwiXaCTI
 Y.9vkmz0sM2YOxl83CcxNvQRspZxv6p_txwWViVa.Jtlc_UT57BVIiUYS7PHVllhXkDBpuopoQDU
 eGUIP4oskGwMIksHGne3uuniRO6JyHqz1vk2qrR6_N8vput5yhlaoE4fsWPxBijR2fseVRX1fkCq
 R9EwggVpjIWGQKKzB.XnmfuJoGtodtVLVndbWUlLNzH4Enap0rVVCxaFAtMoSKZ2exAk8udcvx0O
 bMSpI1EfmB6..KgPVF6Qqsun0QJBG0LQi0z_Jbj0.dWZc001RIHWdUPeArFWjpCjc70bNf7vveuZ
 RZdIOO3eKTsFabQSuKGy03zOdnRniEuCI4q9WDIVC.ue1vibg0BnirAZeOipL0zAXzb7QNM.PTHW
 uvj7eMuayku2T3aa9WeKyT_EeC.IdmRrK9YhKvGqCJolWLr3hChRz.tr0XC9PJjqfMd8v0ftAD5C
 tu6wD8jYRnWRd3eT1SkqzfegndnOVxjlvlBWkQ9IJnQTZwXiLVxfaNkKX8QKrvmwY.VBTCk_BeC.
 37nkHdXVwirUsB4iDU_8t5vKmCUgGwQvc1UDWNu36.1WmneQxgXQjXEruiCLPPg7HtGuqkKLRaoF
 _3fUd8TE.nRcj060dlvhtkZIjEbg4Db8oZQYEG75BfPPCmat14gqV0gdH4ylKwPfio2a.8ltO0Wn
 cIXOkltfFiyjXoPAEFtk9GKeH.mp9CzZUpG8ENBWeDHPet5UI4ppsPXm.UT6Cl8jnhQywj.KBNNP
 .0FjGx7NSMJskV9dj08K6iy0u0riSwZDC.fltw1W62V5hyalbb6fSdfoCZAH02U5qr0oga8neLpx
 xpWbiA8BZt7gTDEXm3SmnHtzbo3Nl9VQAW2Xhs_3mkfMNdoe0KLM_CJtfYMzihUr6f_5Op9_PlpY
 w.ZRL3iVFubrfFMgvVn_RxLvwPsW7Df2Z0GKNxbejX47puc_rCO69LatVfC22YM8BPpdvgC3CwG.
 O2zgsCqvZig9j7GHYZxBRPJ7vwgh0q6dRYFGS86ljHK6btQ5dHhUksAQNs6tFCm3n1jlsdcGvB_h
 oRWa977CQ5TRZcOeoUj7LhxnUP_TdpX.TJSdbRpflSQ3nwI4TbD.eib1kX.AHUFEtUBI4hcAjtwu
 pwdAZOCK98tdHCmxYon9YA4sUk5n37CtZt72YxF_rbCBW4fDFa7ljY3UuVLUoKd2woFQ3LQxO1q_
 dQVT8QUrY.KopxhO5BFdIcoF3OVkxUu7fgu8f4Xnfkx9LCqGbuXxifdANDqY2XGAIZOlF0MEEADF
 LIkQTfnTJzNzbuk7.7IbH2.0SDgAt32DN8_9HkWXaprAqc07h5.31G0Y5czSclilcXH_oj1KPbcJ
 Lk_j9ClVg3cG8FQpAA5yzXPE96Q3AH5sZjxPEhEYhIxIm2fRpkDyKLIVBzm1iZSu0am3BvEyC223
 ff7ZFqR9deX8zO0Ec1om1pBIzEnrkZo.1K1sSkZlvkBCza2FuIP9WQEs.urGq3x721cHZvoNKWfg
 HPVYI3W4Pmfl9pbGaJb6A9d7CjDV3RrD9tEEhWYpiUkR4x3XaOC7F_Vji_8Sqi5kkwPyIys0lyXg
 GLP5ABzv77Vqr1sBXP32jG2JmKc6fvmJ6d6X3MfiL8RW113JV6PTJx7fUWoA0pE1y4zzJn5RxPxM
 u78uIorfTjXiZTxTaak_xmnN2KIetb19HD5BCLyip1vlQ8.x_vCnweRHOHEH.EGcEcr6DcfIxynJ
 aMxI0uDjQKa1gxPZcakZI1zDA31jYob59PeqK3HNKYPG5ciGEnWujQ9RZ041cc_s9q0wbULXq.KI
 3yKCr0nG5c2aiN2U.Nwbx.75tMeP9tnzG6KzR8oua.vIG7HqeA42jnOWo.KOndi0GvODLE2vpNMs
 KR07HDMRIpvjZ281y6670VmNwC6UkEr1dAyb7Nc3v1brJQt2h9UkvHEiX3BuYAkA3z6mqNyD.7QM
 z_J9YKA--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.gq1.yahoo.com with HTTP; Mon, 18 Jul 2022 11:32:28 +0000
Received: by hermes--production-ne1-7864dcfd54-s2f4b (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 5f85adc2208b756781d6358a6215d965;
          Mon, 18 Jul 2022 11:32:24 +0000 (UTC)
Message-ID: <4ef8c3ae-b365-03ba-0e8e-9f4a2bf53748@netscape.net>
Date:   Mon, 18 Jul 2022 07:32:20 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/3] x86: make pat and mtrr independent from each other
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Cc:     jbeulich@suse.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "# 5 . 17" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20220715142549.25223-1-jgross@suse.com>
 <efbde93b-e280-0e40-798d-dc7bf8ca83cf@leemhuis.info>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <efbde93b-e280-0e40-798d-dc7bf8ca83cf@leemhuis.info>
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

On 7/17/2022 3:55 AM, Thorsten Leemhuis wrote:
> Hi Juergen!
>
> On 15.07.22 16:25, Juergen Gross wrote:
> > Today PAT can't be used without MTRR being available, unless MTRR is at
> > least configured via CONFIG_MTRR and the system is running as Xen PV
> > guest. In this case PAT is automatically available via the hypervisor,
> > but the PAT MSR can't be modified by the kernel and MTRR is disabled.
> > 
> > As an additional complexity the availability of PAT can't be queried
> > via pat_enabled() in the Xen PV case, as the lack of MTRR will set PAT
> > to be disabled. This leads to some drivers believing that not all cache
> > modes are available, resulting in failures or degraded functionality.
> > 
> > The same applies to a kernel built with no MTRR support: it won't
> > allow to use the PAT MSR, even if there is no technical reason for
> > that, other than setting up PAT on all cpus the same way (which is a
> > requirement of the processor's cache management) is relying on some
> > MTRR specific code.
> > 
> > Fix all of that by:
> > 
> > - moving the function needed by PAT from MTRR specific code one level
> >   up
> > - adding a PAT indirection layer supporting the 3 cases "no or disabled
> >   PAT", "PAT under kernel control", and "PAT under Xen control"
> > - removing the dependency of PAT on MTRR
>
> Thx for working on this. If you need to respin these patches for one
> reason or another, could you do me a favor and add proper 'Link:' tags
> pointing to all reports about this issue? e.g. like this:
>
>  Link: https://lore.kernel.org/regressions/YnHK1Z3o99eMXsVK@mail-itl/
>
> These tags are considered important by Linus[1] and others, as they
> allow anyone to look into the backstory weeks or years from now. That is
> why they should be placed in cases like this, as
> Documentation/process/submitting-patches.rst and
> Documentation/process/5.Posting.rst explain in more detail. I care
> personally, because these tags make my regression tracking efforts a
> whole lot easier, as they allow my tracking bot 'regzbot' to
> automatically connect reports with patches posted or committed to fix
> tracked regressions.
>
> [1] see for example:
> https://lore.kernel.org/all/CAHk-=wjMmSZzMJ3Xnskdg4+GGz=5p5p+GSYyFBTh0f-DgvdBWg@mail.gmail.com/
> https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/
> https://lore.kernel.org/all/CAHk-=wjxzafG-=J8oT30s7upn4RhBs6TX-uVFZ5rME+L5_DoJA@mail.gmail.com/
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>

I echo Thorsten's thx for starting on this now instead of waiting until
September which I think is when Juergen said he could start working
on this last week. I agree with Thorsten that Link tags are needed.
Since multiple patches have been proposed to fix this regression,
perhaps a Link to each proposed patch, and a note that
the original report identified a specific commit which when reverted
also fixes it. IMO, this is all part of the backstory Thorsten refers to.

It looks like with this approach, a fix will not be coming real soon,
and Borislav Petkov also discouraged me from testing this
patch set until I receive a ping telling me it is ready for testing,
which seems to confirm that this regression will not be fixed
very soon. Please correct me if I am wrong about how long
it will take to fix it with this approach.

Also, is there any guarantee this approach is endorsed by
all the maintainers who will need to sign-off, especially
Linus? I say this because some of the discussion on the
earlier proposed patches makes me doubt this. I am especially
referring to this discussion:

https://lore.kernel.org/lkml/4c8c9d4c-1c6b-8e9f-fa47-918a64898a28@leemhuis.info/

and also, here:

https://lore.kernel.org/lkml/YsRjX%2FU1XN8rq+8u@zn.tnic/

where Borislav Petkov argues that Linux should not be
patched at all to fix this regression but instead the fix
should come by patching the Xen hypervisor.

So I have several questions, presuming at least the fix is going
to be delayed for some time, and also presuming this approach
is not yet an approach that has the blessing of the maintainers
who will need to sign-off:

1. Can you estimate when the patch series will be ready for
testing and suitable for a prepatch or RC release?

2. Can you estimate when the patch series will be ready to be
merged into the mainline release? Is there any hope it will be
fixed before the next longterm release hosted on kernel.org?

3. Since a fix is likely not coming soon, can you explain
why the commit that was mentioned in the original
report cannot be reverted as a temporary solution while
we wait for the full fix to come later? I can say that
reverting that commit (It was a commit affecting
drm/i915) does fix the issue on my system with no
negative side effects at all. In such a case, it seems
contrary to Linus' regression rule to not revert the
offending commit, even if reverting the offending
commit is not going to be the final solution. IOW,
I am trying to argue that an important corollary to
the Linus regression rule is that we revert commits
that introduce regressions, especially when there
are no negative effects when reverting the offending
commit. Why are we not doing that in this case?

4. Can you explain why this patch series is superior
to the other proposed patches that are much more
simple and have been reported to fix the regression?

5. This approach seems way too aggressive for backporting
to the stable releases. Is that correct? Or, will the patches
be backported to the stable releases? I was told that
backports to the stable releases are needed to keep things
consistent across all the supported versions when I submitted
a patch to fix this regression that identified a specific five year
old commit that my proposed patch would fix.

Remember, this is a regression that is really bothering
people now. For example, I am now in a position where
I cannot install the updates of the Linux kernel that Debian
pushes out to me without patching the kernel with my
own private build that has one of the known fixes that
have already been identified as ways to workaround this
regression while we wait for the full solution that will
hopefully come later.

Chuck

> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> reports and sometimes miss something important when writing mails like
> this. If that's the case here, don't hesitate to tell me in a public
> reply, it's in everyone's interest to set the public record straight.
>
> BTW, let me tell regzbot to monitor this thread:
>
> #regzbot ^backmonitor:
> https://lore.kernel.org/regressions/YnHK1Z3o99eMXsVK@mail-itl/

