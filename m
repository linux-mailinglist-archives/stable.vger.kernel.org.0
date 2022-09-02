Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B665E5AB812
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 20:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiIBSQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 14:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiIBSQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 14:16:31 -0400
Received: from sonic307-55.consmr.mail.gq1.yahoo.com (sonic307-55.consmr.mail.gq1.yahoo.com [98.137.64.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC8BFBA53
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 11:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netscape.net; s=a2048; t=1662142589; bh=s3DCCzDNWNr2o0vPxVJ9J8EDP7JjOQZ9oV86ErYAcgk=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=UuNBq5trwqOT1Zuujm0ArLr2nPzjtmN8ffppps8EfjK/dn5fgp+PUz21acySDzXRwIeSWYzGMpPNc2VuN7nSz+cig4tZXavIy8QAWayhAqNfNcO4yGyHBoWLKa0sSc8R3tnHPujLHXBB9nKhM4PUV1ARfzbLKcKwAmlXGyCXoRraXqyz+NDaUlRsmmmO9NTe3J1n5dpsUPu+unZ5Iv8WbiW9iD1QJqIaAoWl+s5zUCxKN//Zdxh6Bi0tnVk/+dTGVOH/Ffy53rZi7+3+UntrD9JQfqaAANsHWpJBrfLWy6YKKc+AhqrTKBCV/HluDpf1R7CWLQ32xXUdMndX/NY5Yg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1662142589; bh=VvLErFLgLh+5dIOl2uvWFYlDdU0cahVwaqvOzOwjaAM=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=bDTK+ytkf9CMrXOGh18DUQOUnyn6R68Qaxvp83PR5LkB90bNK1Q84Ke81P5YWfhSVxb7QGSPBXHru5MgKeDCEVGixi7g42GeGhP8jTUFSK81SPvj6tIYNcVJ+oys0qUkQ5gxPM0t4lBBeNRO6Rj5k7Gl2WHsay7cO858ky5RwUQvLWp05AG/HoDQPYlZGxmh+FkYRhqZyKpnFPKsct4gdaXGn2BajAC+wnq814et8+thMG7g/k9+bHGCY5fiMcxKd5Ot3/hY9ZnfT0wkDbhbZakxlBreVEhJJ4Tu/RDRxSKsai0ZIaIMOQhw2pkirc97krvXZgiE2tpU24XYm8T0CA==
X-YMail-OSG: elTm_NQVM1lvo38G3pIAoKx5MoK89Uun0JR2_1wE044d8L.ehf_ryNlBRjgcYPY
 YZG0ZfhLxIMgKOS6ZLcWskXATrt36jxlJYWarmF2X4EwHA8DhtSClnqFh5NE940ijcStWSqFqe8b
 Z2CWFEzX0H0nq8YmzY3uLj02SyyZO30aKhIdyEB8oWla0qN92dj.3l3HIaNYlrIGozGHNByPA7ZJ
 0oFjphkXU4kVxWswObHfHl3fPxPa4VargLGzGUR7l6zOXNGrPCK8pmV.gMRo5byomb55u6o6NkXq
 y5Lp7uhpwvw1qXp8acoP.u9y0Lt710KmPdJOgwEA6qE9FaK7CYmSvSE3HU_jFdeKgo1m67QoKDuF
 n.U5xvsRZog642NXPY40tKM1n9KrUpUv0kQzjSPl0fjqhnhf.T01knY.rb_E8Q8dYj5BDyR4oJcB
 ojmprrMvKLITce3FjTtjX6G288fYFfyEyLW7dJHC6rgu2wtpEUHWxYIV0wg0Z4ComBqrO5HtoilW
 EB1umH2V02Ljm3b8Yrdh3tmuetofzHHnwq5bJ1POfSFV0GeA2JLt4ULQ4NsRmR17O7qPKzSXiEkl
 elG2DYrZ9jxY8RsctW_VAQob0OWY5JrbtToKwuUpkDVbbzZHr14dm.T9t6FDKfPV4grhhbq9suzr
 KgbsR6iPhwCm5BUuJcEGwkNjrHSSq_sf6jq9wT64Jyoo3SCcLwrezQYRhlGNmhzSA59iezIWru0B
 7G.TwmmyF30oYYMvkLK3KzndqOfroyz.7Z.fW2elpjNfDklRedvadqqHEznrOE9.nSDlD2tQNZFl
 mNbsjE1WvdaAUYxD4Vip6m6yi0IjmHOcIEBC6dQwHY9RuDozXFdv15O4WrzOEW8KX_H5wrc3DNp2
 _Y.8WlK2lGK_E2_CxuDFf5KVp7YksYbb41c3N1aqT.r_4o_X5zf9WBL9OtWBfiJy2iJxS9KomQ9X
 2VzPe6sEw.ZKUpV7YSEFcPMGpCa7FvEYYczH03HrT7_F3oCFgAoj4Qubbj6AAhkMLPJYbOcUN.JR
 qUbpet632ZHTQ_Whqw8d88r68DsGF4GXTdSAeArb8.nX8D.kGO5EKN5YDT8Bgn4oJNHBKtfe756I
 sYqOU0hjQRyTWRIVcwUXciV6M8PhYi4Fn85tKKuNL8OudLJDmcpIPHt7CxRVE9BnL2VTBMZsXrvu
 8SXBxHzQ2k.1gUzkDMuCTHdkwHLTVVQ8SYwOEN2zzYatTVtXbG23wmOIoZJOH4n81YQ_AahL80Jy
 hwE1z0V2nuYzi1_X60VKkTKpBq4xy7xSyXEY0J.HQadpJVrLKyTXMRf9x_lLC20AMZ3xCBBSoICS
 j3FgRBSFfqCoeqeYdly5cuY2PneQHy6eX1HBB_dxU0R3aoSnbdTayfW9NWDcGd1aGfZnwyzvB1FR
 aCAAQHGKXIvvKNqUo_QknYBQZECW1MtoWr9kZmC5pudUKSsKDbyQECxOWvvNpAQXeJ3wVG3ooeTv
 FM6r2aUtBEgdkMaq2n4z4nGhdZuh1HqPLwJ9PSwrYPHYAd87T49QoENXlVapo522sVcNTvvnENWf
 3tgvgvWcD.x8murBmFWj9TXzywvrfojN2KlTtJDGoqPafC4_.uIweMcymfoKt0w_68xXJ_Ep.ZR0
 _pCllwN5igeq4WGb995RwjbbNqPzCxrNsC9m4rvTXJX5eqHaj.eUN5ZrP4GANbN79LEh.92T5zk3
 irwIz4J4S_I182jD.05157zzQWD9S6tIGO1rrmHPtcvEw.S_hLPmISeK082DwHPQRHuCTtCeseV.
 Cx..DSGvRzrtIV5SEUFSnQKPiIoMzl6GFxUOqCziahuo8Ok5Dp2.jcZ7oV2wx2QazGh0HMKrSSYn
 YmxKikSBsPPOCqq3ma6YE0Rzy8vQX8EsmKolGVNOzxz3DKmGm2tTF3OfVrs6NW8iRr19FviEeLvY
 kviOuxP_aoHzHUBSulSBn4tdOnso3M6VmyJo3X75IB5usdDKOKDOq4GJwOotO.etao6o8her0NxU
 jG6xyvQ3xQXzCoRH1RmYY1OrZ3plAcHB01C11CLH7sLhf8A.JR0U4KAkDtACPzeCggkKqmtrAgSk
 5318qYdebdxGn_LbHV.fxGVF_B6vrYOxLyYAy2SN4Hz1HbUINxuZq94HPG.iqzKsOeSQUS92Uc7a
 YzgWDpN5FnHoRSgeQm1v.dfZxHmbU7udKyqBFeXL0nBGF.D7XLZLoF4x86c2eilYN6nxUaRj5LcP
 _OuE5sVtFO0Fw1xYbL78umu0dQzh7ZJE2fj7x
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.gq1.yahoo.com with HTTP; Fri, 2 Sep 2022 18:16:29 +0000
Received: by hermes--production-bf1-64b498bbdd-ds6cg (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 0e5b82ec19e7d0722a50a09162dc19e5;
          Fri, 02 Sep 2022 18:16:26 +0000 (UTC)
Message-ID: <dc553a8a-d71b-9a55-be16-fca16ec92f01@netscape.net>
Date:   Fri, 2 Sep 2022 14:16:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.19 109/158] x86/PAT: Have pat_enabled() properly reflect
 state when running on Xen
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Beulich <jbeulich@suse.com>, Borislav Petkov <bp@suse.de>,
        Juergen Gross <jgross@suse.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        regressions@lists.linux.dev, lkml <linux-kernel@vger.kernel.org>
References: <20220829105808.828227973@linuxfoundation.org>
 <20220829105813.685677959@linuxfoundation.org>
Content-Language: en-US
From:   Chuck Zmudzinski <brchuckz@netscape.net>
In-Reply-To: <20220829105813.685677959@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20612 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/29/2022 6:59 AM, Greg Kroah-Hartman wrote:
> From: Jan Beulich <jbeulich@suse.com>
>
> commit 72cbc8f04fe2fa93443c0fcccb7ad91dfea3d9ce upstream.
>
> After commit ID in the Fixes: tag, pat_enabled() returns false (because
> of PAT initialization being suppressed in the absence of MTRRs being
> announced to be available).
>
> This has become a problem: the i915 driver now fails to initialize when
> running PV on Xen (i915_gem_object_pin_map() is where I located the
> induced failure), and its error handling is flaky enough to (at least
> sometimes) result in a hung system.
>
> Yet even beyond that problem the keying of the use of WC mappings to
> pat_enabled() (see arch_can_pci_mmap_wc()) means that in particular
> graphics frame buffer accesses would have been quite a bit less optimal
> than possible.
>
> Arrange for the function to return true in such environments, without
> undermining the rest of PAT MSR management logic considering PAT to be
> disabled: specifically, no writes to the PAT MSR should occur.
>
> For the new boolean to live in .init.data, init_cache_modes() also needs
> moving to .init.text (where it could/should have lived already before).
>
>   [ bp: This is the "small fix" variant for stable. It'll get replaced
>     with a proper PAT and MTRR detection split upstream but that is too
>     involved for a stable backport.
>     - additional touchups to commit msg. Use cpu_feature_enabled(). ]
>
> Fixes: bdd8b6c98239 ("drm/i915: replace X86_FEATURE_PAT with pat_enabled()")
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Acked-by: Ingo Molnar <mingo@kernel.org>
> Cc: <stable@vger.kernel.org>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Lucas De Marchi <lucas.demarchi@intel.com>
> Link: https://lore.kernel.org/r/9385fa60-fa5d-f559-a137-6608408f88b0@suse.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/mm/pat/memtype.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> --- a/arch/x86/mm/pat/memtype.c
> +++ b/arch/x86/mm/pat/memtype.c
> @@ -62,6 +62,7 @@
>  
>  static bool __read_mostly pat_bp_initialized;
>  static bool __read_mostly pat_disabled = !IS_ENABLED(CONFIG_X86_PAT);
> +static bool __initdata pat_force_disabled = !IS_ENABLED(CONFIG_X86_PAT);
>  static bool __read_mostly pat_bp_enabled;
>  static bool __read_mostly pat_cm_initialized;
>  
> @@ -86,6 +87,7 @@ void pat_disable(const char *msg_reason)
>  static int __init nopat(char *str)
>  {
>  	pat_disable("PAT support disabled via boot option.");
> +	pat_force_disabled = true;
>  	return 0;
>  }
>  early_param("nopat", nopat);
> @@ -272,7 +274,7 @@ static void pat_ap_init(u64 pat)
>  	wrmsrl(MSR_IA32_CR_PAT, pat);
>  }
>  
> -void init_cache_modes(void)
> +void __init init_cache_modes(void)
>  {
>  	u64 pat = 0;
>  
> @@ -313,6 +315,12 @@ void init_cache_modes(void)
>  		 */
>  		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
>  		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
> +	} else if (!pat_force_disabled && cpu_feature_enabled(X86_FEATURE_HYPERVISOR)) {
> +		/*
> +		 * Clearly PAT is enabled underneath. Allow pat_enabled() to
> +		 * reflect this.
> +		 */
> +		pat_bp_enabled = true;
>  	}
>  
>  	__init_cache_modes(pat);
>
>

Dear Boris, Jan, Juergen, Thorsten, and Greg,

Just a note to say thanks to everyone who worked on this regression.
I just upgraded my Xen PV dom0 on fc36 that was affected with the
Fedora build of 5.19.6, which has the fix, and it works fine.

Thanks again,

Chuck
