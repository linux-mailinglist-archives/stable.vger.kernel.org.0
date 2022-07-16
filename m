Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A65E576DB1
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 14:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiGPMDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jul 2022 08:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiGPMD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jul 2022 08:03:29 -0400
Received: from sonic304-51.consmr.mail.gq1.yahoo.com (sonic304-51.consmr.mail.gq1.yahoo.com [98.137.68.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755C823BFA
        for <stable@vger.kernel.org>; Sat, 16 Jul 2022 05:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1657973005; bh=DAM/bEP7xnNDHYTVl67GsU8rgaN43Xl0MJMznYJcJ8k=; h=Date:Subject:From:To:Cc:References:In-Reply-To:From:Subject:Reply-To; b=NP41fgjAshEYihUjHn3vCQb5C01OBhdiioWHeY+5uv9KuLa77wA7bT4hLSKPulU9KLcAuP8QA/fWGSI/yZJA1J53tBLGn2vbgKWXokQTnrcbThcmY51hB54mvG7ddAD0Wnpot/g0gSYer8FzyjqSPTryrZeVmZn1hX0f/lg0TroTzRgwBPluhI7HciiC40Day7CFXrIGeYs65PK4bH93MSmaFjMgNs+UzoohkjzYIGCc3wlzqGYn3x+erVkcQerCs5WN6pTr53KiTbZ6J6PgqpoXcMC+xxdIJCiGDKBMLr7Dp9J4G09dumyL6/8978uBPTD3hoKxiQZPGsDtKO3tNQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657973005; bh=+hW1DQW7YFURSc4bkniM2nFGuTDWQjmcm2vfVIrE9Y4=; h=X-Sonic-MF:Date:Subject:From:To:From:Subject; b=Q6+0mwXVEJtGc2uIcAK2YSoWUszCUKu85XQX8U7hqhjlvxPOQRVEwEsrLx+6kSqiaoRGpbJZDkjYx5teYXBtqd39zPFyESjBxiMIIAoxyYY/P/sg5EsLND0AMHNKLb1hGvUvdbqGzYGuBbNQBjGcLbRdcyIz9yXF/gMSJBkg+n1NKsk1WjfKJcQN5YdZ7qfJCKqceeA2LhRmJlfOz6IiFoGup9N8FQrO4e9qyAq1StQPeRKPtFq1bkyYS6Vw/gxh/SOK5FEBq9FSYYXeK+L2sADzU4HxpjBm/yE//2mb/TQoame8aHGwjG4AJAcuo7MLPB/S79SHpr9tbDBBLgn9hw==
X-YMail-OSG: UyYPEY8VM1knZXXCuCD9X7SMCCLHmK47it_NQ7T3OD6p35j98RQWU0OArQdTxwE
 Tv5lMIOAFO6E2gQX.W6NBOoIY59Fn9QsdL0WKVOpcQqcUkJM3YzpvCeRt3EgtT.n_ys8T6z6YTDy
 lhVqxN2uFxa.o.KQWB4ZgUvrG4x0ZfZ9Gd8hXfeYlg6jwQxzbg.UqjGrXYvpCmB6YRp0GkpuYn6z
 pYL2pjjizzaTCsWS1kdTNsa9LVPYpdc_uuvnKSuvSLY05TDnD8tniwtBriJf3mexDfrvMNDFdgAX
 un7ODWI9OQBr.ZFWroiKNWXsL_iWcypAbHGseQMpalAkzuCact3nvSPnEJWR2yxcoxWuOCJzBiix
 44wMH6uoLZQovIue0xCp7dKoRXFlSRAW5VNggCqK7hqnWE3umaku5_yGtayouv2fla2VmF0XnsUs
 M5tmI9GdLz1GMuth_9NJhkQCAZ.5iI79inO1OAkdIfWqzSnmQaCPgF71SsTe256sJhN5ue7ld.Ak
 KeRaJIBKNoUDWTpgI5wWhbK3JTgSC9FYgy_WxuIYLjZiPlBfoZrPtktHErLisikKqOXArXD6x.s0
 KWCqQz1i06Ch2AavloZ1K54HPiXYkcnw_SVd5fpN7.E4jBFS9EIs9ec7SgooW3S6WZc_1ZNJZoZt
 limpkLNDPG9TSt_fxWaaMdh3vKnDJYGe_sqLo0NRObJZz5qBQMJmyZNaahD.5I_JU9GvnLHMh1KO
 _Iz88ifTyBgGe5X0HNWLPwy56ivkxPoMvL.LRkAlf_6Rzkp.DzhZZOjIKT3EQs9L3.nT24zXxoH7
 zNS8HDJruz__GJb4NYNmAUzAOT78aEzZ_Wr5g1pKkt94h8TUsfGHT_KqnobnEAe0MqhCed6UaCda
 L8X3veByAOWVfuRjqrYqcdjzxosEaj1vJE0zMolLBVQDSCWHPuuMOw8GJR9OygNL68OYl2YDbLFI
 36qiT5T9cf_yqCyM4IOGcWmNZ_7oP80TqLU7MzkTZVoIpOK6ZckdLqmG4MwDhfwePWkSy32QLrIm
 03fA7cUK1Z0XdYzN9tqh9l2Sx7DqxTbhmj5vCcXpjZjOeMwfLmmqnN4SeBhXg862LdHzql._q3or
 zp8ccokJmgb.SBEXUbgpkHFbcnjmGEIMIyrbUnuyH2wm0TXyAqvYcXSre8_s3b5H_WLB_ms_eBjx
 0yNy3dWFNV1YsPhix5KFACxsrj8jqjrwCKIylbhRSQ6JeEx.ADf0M2sIsrXzvRSHTq0N33dbQcBf
 cm4mHGzsgolEroBnnIrWlPvKFkFqYdlFuA_9pcTXWUvatBwalFEupzp7NZZj3K8MgiN8pDUPGJRe
 ymuVULKAMnLxOCjuXqfBEv4HFBsxSR9.E0MH9rRukA59.wXby33kr0Q3VEmzKEoOcWkxi7zvi7gm
 pWSngiyu5i0b2Ff05ruxewFf_4bYC.XKAHrH9PtMcqBGfvnmgoM_qnlv0z7Bu7oEMUccunlRjBm6
 LgY7wBBlFCx0xPUUArhXv4s.xPLRkCZG7_40fqtB7nvqME2c.9iTQVQVjcrgoC6792I5A8HzwBTi
 1y46aQjhUp26giE52sFny7k72JkjmdZ5TOiYBi9Omjw.FyQHofL5DonUzl46T8sf.80uAS0m5MF7
 QMVmkf4VytjBOtuxcwPca67UseXeYoDee2uz6Vi9drl0wRnHJVo7By4EUW1V7WFm_a.oT3_bfXyL
 oMEpf8.zN0AZJwqbglnUXZb.VW4vSh1EAGBpfJOr6oeQP_bWyMpbpfLkZjw.MCU0hoAZFK_K8Xts
 eHFnU.RpR98uMGoB1dzQqrC4flHL.QyyneeGOHuxoPyLjffmObTueEbtxQiIWWp3SnKvqrBWxdfj
 2wp6Bf6DETmwz6rMpC74pdJqNKEQ_by8cqXyK8kSIU4FjOBcNcXYyYh5A2OZybWv9MsNwJgnAIyC
 mV29Bd7EvTpcjm_FYghulo9hevzrXcSQE9l836ACoaTzty79ShCgiZEyS0P0jPvTOSO_Wgufr4HW
 Q7uJXRCij_P3B7yBfay9QVNTQ48Rq_EV0EBSyX9D3T5SfPl.qFr4g.YXv_FBwQ9c1ZzYpcKHPq4.
 wluTRmXIyIM6RFDKzwoVLvXRz1mSAn_26s4_AJ1mGGE_myeHJBLXotfMCLDlx1W2Q2BuuDrzrZbq
 sWfgP6QesGJrR10ZdZKhY4RDE04GDrnLxlqppV7cTfQXBf32jMlfMfnB1jYkWxOUwinpplyTPIbM
 x9HwiLw7xhm4AIwJ4Xh.Op5rnDa2W1MPm
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.gq1.yahoo.com with HTTP; Sat, 16 Jul 2022 12:03:25 +0000
Received: by hermes--production-bf1-58957fb66f-qrtmg (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 15342210b74ec2b3efb792f6ae39851b;
          Sat, 16 Jul 2022 12:01:22 +0000 (UTC)
Message-ID: <a5fd5d8f-c360-ce4c-57fb-504f8998190c@netscape.net>
Date:   Sat, 16 Jul 2022 08:01:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/3] x86: make pat and mtrr independent from each other
Content-Language: en-US
From:   Chuck Zmudzinski <brchuckz@netscape.net>
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     jbeulich@suse.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "# 5 . 17" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20220715142549.25223-1-jgross@suse.com>
 <7bf307c7-0b05-781b-a2a3-19b47589eb8a@netscape.net>
In-Reply-To: <7bf307c7-0b05-781b-a2a3-19b47589eb8a@netscape.net>
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

On 7/16/2022 7:32 AM, Chuck Zmudzinski wrote:
> On 7/15/2022 10:25 AM, Juergen Gross wrote:
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
> >
> > Juergen Gross (3):
> >   x86: move some code out of arch/x86/kernel/cpu/mtrr
> >   x86: add wrapper functions for mtrr functions handling also pat
> >   x86: decouple pat and mtrr handling
> >
> >  arch/x86/include/asm/memtype.h     |  13 ++-
> >  arch/x86/include/asm/mtrr.h        |  27 ++++--
> >  arch/x86/include/asm/processor.h   |  10 +++
> >  arch/x86/kernel/cpu/common.c       | 123 +++++++++++++++++++++++++++-
> >  arch/x86/kernel/cpu/mtrr/generic.c |  90 ++------------------
> >  arch/x86/kernel/cpu/mtrr/mtrr.c    |  58 ++++---------
> >  arch/x86/kernel/cpu/mtrr/mtrr.h    |   1 -
> >  arch/x86/kernel/setup.c            |  12 +--
> >  arch/x86/kernel/smpboot.c          |   8 +-
> >  arch/x86/mm/pat/memtype.c          | 127 +++++++++++++++++++++--------
> >  arch/x86/power/cpu.c               |   2 +-
> >  arch/x86/xen/enlighten_pv.c        |   4 +
> >  12 files changed, 289 insertions(+), 186 deletions(-)
> >
>
> This patch series seems related to the regression reported
> here on May 5, 2022:

I'm sorry, the date of that report was May 4, 2022, not
May 5, 2022 - just to avoid any doubt about which regression
I am referring to.

Chuck

>
> https://lore.kernel.org/regressions/YnHK1Z3o99eMXsVK@mail-itl/
>
> I am experiencing that regression 

or a very similar regression that is caused by the same commit:

bdd8b6c98239cad
("drm/i915: replace X86_FEATURE_PAT with pat_enabled()")

> and could test this patch
> on my system.
>
> Can you confirm that with this patch series you are trying
> to fix that regression?
>
> Chuck

Chuck
