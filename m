Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A577F5725D9
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbiGLTka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiGLTkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:40:18 -0400
Received: from sonic304-25.consmr.mail.gq1.yahoo.com (sonic304-25.consmr.mail.gq1.yahoo.com [98.137.68.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3718C11CA2D
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 12:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657653370; bh=LqsIYiuRO/rQshDsBrwWzPJZc3QmrOrPF5Mlw0dTQhI=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=CGAjtpR5+C4HS4XQ2OvTYQ7qRlySax9XYLbliqAR29CfvkgIwl1RdUv2Gq/5w7tCk/YEPyImtAySVW2fLavPN7ALOFePf9c38I0R55eo7I9kTe9pgvAbK/7gWzEOQlF+/KkUZ7h8y40SM8wa/sErYdC7KL9HqsFtDlm5AukXsIAY2pxJFuWy5k/oSXssEd/YimB1E5mnEJUYdRHAYyRx38O68t2D7OeONT3dzW+35L5RAKK1NjACcVieKIQrmO/9eDxUggdb/1PAS6kio0CsqzsUflQITVZJLIZwhehNkPBRNjNj/Veyb9BG5A+qnPdZQ4vcppzYBq72sInOkUenJQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657653370; bh=vzUhklzVTkk5kQMXp8RwJ4d116VwwqOH3IvqSm/1z/S=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=ZOxnEwzj99oX1FcCZKrIzFRVyzGKSo/eTTbzAlzhMluX+rosfpIIfAjsApnxXVs7loFbHvnSOI+bEWb02AGXfviau7YgwHQBykvurQX/gfE6qoEnNpOrW2vLUWHtj2m2G+JuuSFgyYZjBr0q27k3HVaJFHAOnMgDGB65hM5HCJ3gAKDRAqQWsq5Z6Bi8ZxHiLAyibPxRQLRY2koYnr/FvVOxEBmUvnBnVv4nQM+XA4A7q2pRXgGyuFiViCaSr8wsZwLG6FLowYfG22OAXx2/hViRR9p+mdz3F6L83ITwrZ6jdWtuByP3xozWI+VIBP8E3n60R08bh5eQ69/x4Y8KKg==
X-YMail-OSG: zNFCnf0VM1mAICJ7S6iq30JGBNQGhtyv7Q_U.DPJjW6i5EJGwBBaz8vDAkB6f1n
 Lf.hiaTiHFLgYwqxKlUAmYERr9tr3YRBL6Z0YUQf5By1TTWCw88Nqq2ztmwOsnCWrKrBEWNjdYHK
 kJgodWMEDJjmuknTFFRpFILt0Bn7O7lnrfkJ_5x7dLDXAb9_16ZZWglvHrPQyGOZuHB0bpwcQa0y
 Ui40DpYlaPc6IeXObZCbcSl8jsG6PsTFV6a18LIbXZi4KjlHySHd7ufy8Rzb21xFAmTfjpJoNwEI
 jhL6wP88QJIMBB.qrptyLG1uEGmuTPtD37h86EpX5JUJNJYxitGLSxIvimFaqvDtYC6buK5ybCWr
 hr1p.XUc7deApGm9mbyy9q_KkLFkP3RulYPtsisukvNfX4eVWCdSRDuf_9zIrWjA4WaxV.XDjBCw
 P0KETDQWsOkrL11asuS35IMR696QvRmTHkyCD7c5nvHYYYjEAiaaWS74NTHGaJpdjzU_irGdCeSW
 UgRkTjRPjmFlOa86_QVICDJm23q2kDtzhYqYbelNC9zW6sVg6chuMLDFfclzg6.QIoD7AfoMlIkd
 wUyODmebdn9_l3wuYL4.FccIUNduFuy_MgcHqQ5xIcAC6RBufP1XCqFYwO8QW8LD8NvzJ8qFChT2
 eATnYUufnI4LzaMmZulgPxqzQr514avDyQ_rzIm1R1YYIe8Qoaf9cTF1QLP4cc5e5UIV8o.DTNVw
 PhHTi6F7lsb2LppiySSYhFEp8iYXlc.EGKbiDPmaRCEEUvjW1bV7iPi8ZJHWkYdue5Eogy_gRohV
 AU.Y1jfVNPOJlzGwyD4qurXCyTGuZ_uHfiM6sAxqjP7uTmbN05qM_YG3wZgF.ZIAmd7r.GkjHN.W
 CCiqZ9z0RpLlkWM5akEt1FTBnx7KFa9Def3FvMaMoPMeFem_apdwdpEY0uiKte9Wcxdr2HonTqEy
 o6gY4R3sy09WJvKKNwRCGDUDNwJeGf61UWZqGFYALsnaJ_i.XN842IrqFTPKcA1PcywNc2M8aqca
 EBPI2aMI9LZeMVIUA57qmdySR41ZnoDYcGSTBtApAnb3PL2GJjdYvag8WhRH7Ya.Hv8powYvZQo8
 KSt5fnMlFScQAs.__hjgna2HVJ5PuQ5Y4Y3UyqEG4lOwp_QEYO7W5Z8e3cpgabuqC0orQ75Mxh4c
 e66Ajx6kR_ZU1emqoa.nCo5r1ufnaD0_h9nLTXEGRhfin1OjKqwB355qcTDNSSpRAu0yqURFPzy8
 QJBWgQajGuLwCccNVPeW4eqrJgzxM9vPAF3wXwqC81TTOuHsm7zH9Q6lYKGHMdfDYHJYl7.Q5Fk4
 wpMuZ43o6OgPev8a_wpdG1yUgxcVMIVkCztLPudUSbmqTYhrJ5KJ8ROuKjKyhT4UG.pjrcPYeoNP
 yUcQ6elGOLSvzqDSY8EmxdDfPW5nP6NLs7nwhuL4st298TxyVBXEdZVsAHKYs33M12SMx4qXL2BT
 SZPliQpq1sOZ9a9HxB8JjZMu_m3giUGr8pmCCQ6iWJfVrZKIaNJZYGQ2hgXz_UpElnXIrs2.bjoy
 OdYL.tBFOB7YGLETRhjjo3gg7zVjR1H6mPAe6ehmTnff6IgrPDAqagfg9OSdPjafoshfGMQ4VgXI
 oHo4Am.FX.ggDWvxnm.yC5OeIkP8p7xZGBrxavYWQKSl6z84dpyllgj2fh9bJT0sIxqZIfFPrEmo
 uWZPeWfncD8LubnMtRdbj6ZrOWanPZ178BKHsylxYYe6Tq787O_uKcC6sUG_lQ92ItKss7opjBUy
 MueB6yp_NbmnbnEqGwcKy6uC6yuKytq7XMvTChBZeMJEn61dVyYQKYGCRivtlywqTO3y1zaMbgWV
 hwfFx.lzoVaNsodAorcUhlPFcIYRgcjzhZmtQ8Tq8._tGZFfk8JRWLJ_1xYknOwdGIuARmvTn3Do
 UOidztSktYXqOyHBvX2HeDSw6_1BxB1NE4_6iG85nGVCJ_A3_E4sMPw8EuKyRDzfMmRDDikyzhZu
 wXQUa4_XpJh.9rwfToWo2zbFb2oVaLFog7.BlWfMXzwt3YUcH03KetFvmqT8XhLFThUD4No.tidY
 FmLjC96V9CDOhuT8msHkOO0fjH2tGKa8ONrEaFV3TvGUu109DhOdkbA9IzA1iRtAlZM0MB8MsUMn
 lNG62gV6G.7TuHImInynmdwpcf1zjH.viwLTL1CmCBF3SKDVM8swISGTG8Se8BV72p.uktB3m4Jq
 5_8hW15w-
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.gq1.yahoo.com with HTTP; Tue, 12 Jul 2022 19:16:10 +0000
Received: by hermes--production-bf1-58957fb66f-h8ftj (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID fc41fbffd72b8c63f02a9fec28369f25;
          Tue, 12 Jul 2022 19:16:04 +0000 (UTC)
Message-ID: <a9efcbf3-3b34-53b7-0fa8-55a5ed3a17b4@netscape.net>
Date:   Tue, 12 Jul 2022 15:16:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] x86/PAT: Report PAT on CPUs that support PAT without MTRR
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
References: <2885cdcaccffd287ef69c7509056ddf183a38a0e.1657647656.git.brchuckz.ref@aol.com>
 <2885cdcaccffd287ef69c7509056ddf183a38a0e.1657647656.git.brchuckz@aol.com>
 <Ys2/Lho9vQO33RZc@kroah.com>
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <Ys2/Lho9vQO33RZc@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/22 2:36 PM, Greg KH wrote:
> On Tue, Jul 12, 2022 at 02:20:37PM -0400, Chuck Zmudzinski wrote:
> > The commit 99c13b8c8896d7bcb92753bf
> > ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > incorrectly failed to account for the case in init_cache_modes() when
> > CPUs do support PAT and falsely reported PAT to be disabled when in
> > fact PAT is enabled. In some environments, notably in Xen PV domains,
> > MTRR is disabled but PAT is still enabled, and that is the case
> > that the aforementioned commit failed to account for.
> > 
> > As an unfortunate consequnce, the pat_enabled() function currently does
> > not correctly report that PAT is enabled in such environments. The fix
> > is implemented in init_cache_modes() by setting pat_bp_enabled to true
> > in init_cache_modes() for the case that commit 99c13b8c8896d7bcb92753bf
> > ("x86/mm/pat: Don't report PAT on CPUs that don't support it") failed
> > to account for.
> > 
> > This patch fixes a regression that some users are experiencing with
> > Linux as a Xen Dom0 driving particular Intel graphics devices by
> > correctly reporting to the Intel i915 driver that PAT is enabled where
> > previously it was falsely reporting that PAT is disabled.
> > 
> > Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
> > ---
> > Reminder: This patch is a regression fix that is needed on stable
> > versions 5.17 and later.
>
> Then why are you saying it fixes a commit that is in 4.4.y and newer?
>
> confused,
>
> greg k-h

It is true the erroneous reporting of PAT goes back to 4.4.y. But it
was not until 5.17.y when the i915 driver was patched with a commit
that started using pat_enabled() instead of boot_cpu_has(X86_FEATURE_PAT)
and that is when a regression that started annoying users appeared
in the kernel. I presume that we only backport patches to stable that
fix regressions that are really bothering users, so even though the
problem dates to 4.4.y, there is no need to backport before 5.17.y
which is when the problem manifested in a way that started
bothering users.

Chuck

