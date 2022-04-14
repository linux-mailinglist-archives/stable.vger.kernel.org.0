Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B47501F47
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 01:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347754AbiDNXoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 19:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347748AbiDNXo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 19:44:28 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0220B36AF
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 16:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649979722; x=1681515722;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=octI8gkuUdPp2CcD7y3vKEWC/6kqL3X5ZcA2TURCbbY=;
  b=QCxkInnhm0m/dn6q0tmA7eAh9bDw7bjBIWub8/Sr6rF2iErjb4RnJfBN
   GJhRcKJ3L3Ei0yGoEjs2zBh/C2gN7nv8D15Q9X3KpYblqpaLshEzd9Kgc
   BxDQ3+7a80in3/b9dv49MoHVgP6YKEj1Q1V+NZxhWe8jh8O3h67aU7kEf
   Aa3dbDH2c6L3deA6cFWE+TiB2qIVXcjUCMBon3hlbXgZPnFuV+ISCspPg
   xnzMtOb8qtNWCXKqEpC6z2H98AKH1rp08ALw5fgbO+GRVZR7Uvu7+IeWA
   iHwk87ftAGX/ON4M2U0IPyK2N6Pg5i5msA7M2GzR8eKOY2m+FNv7R7cP9
   g==;
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; 
   d="scan'208";a="309920056"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 07:42:01 +0800
IronPort-SDR: BwE++6R9+Ra5PSz03kHdpQCJu8ONF3K/4TruRnkeP/raxXr5uqRU6oSStAu7ZDmGtmJf9qBgT9
 a9kqIxMGbtBQCmHgnsbohx2Nbvfn/OJIHgpEBgUvFIxQe/mOtltPkygkbPhGxWa0eVx2ZNRXQK
 aF6dqBqldKfaBIRRFpkKUU5TJTvA0/COc4x2lKdDkykLeUAuERJUtgP2a7q4Od3HtJZs+O8r1y
 cVUXF2HVCUAIcLFy8uZGg2Zo8bWiP204G1Va8Ipixu8AFctpUZM6DFKFhBk6cu2zRhyMo7k54/
 Uy7bWxw0b0zObIaTDZzQxLix
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 16:12:27 -0700
IronPort-SDR: ndJnVxyT6QJVTTqWVrLSAMIEQn8EEW39hxvD2oUTrjN9DbQ95DbP0rB/yL9LkQjZUjt344AVzG
 7KZ9A3n2QPCcz9AW+B1RbVKKNQK9Iel5L7R8udluL8iYXgvji7C16/sKu/mTDHnLFXJFmYH3XU
 ZvD4bO5Mrn7JrWKezLGbwYhJLOUMjpTMNDkZH8AavvhcMsdfkayYano6DkzgT5Wzy38qGLvfWh
 tO+YtCW4bbQ6wtXSl0oQdsiRdzo4wA80dImwX2f+zF9Vb6vm0fyrdStOP0iW3Ld4D2hPjxryCL
 v1Y=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 16:42:02 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KfbbF26jhz1SVp6
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 16:42:01 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649979720; x=1652571721; bh=octI8gkuUdPp2CcD7y3vKEWC/6kqL3X5ZcA
        2TURCbbY=; b=G8u3sp4M11CSasP2r1AQLolHkzCU61yyv5FwdwwXq4CypIYTAnH
        hGyML2VTo37SlnJ9Mgk5XyJhd01IXY5KeJdsnBN8iKFe3L71ueTUYRYA1dKm/Q3h
        OeieM9OwF+JDY+JUsMXV7vBYzylsEK9jEj5n//hIieuSziiWR7dUOgd1xX6WlwZD
        miasY8fSj3Q7K7nemKO99tJ3LrlcOpZK3FpOM6uBS7pT6Ly3pq4NCCFEggimhqFg
        1oOm7TyQJrpQ8icbEc176i79M8XmZw+lTmLadQG9q9348w3MXGxYfLM4MSQ94Zv8
        NsVkd07JhCSjOYZN5yR6fQdvhg/eLTFYX+A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id l0bou-tcn8Ve for <stable@vger.kernel.org>;
        Thu, 14 Apr 2022 16:42:00 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KfbbB0qm4z1Rvlx;
        Thu, 14 Apr 2022 16:41:57 -0700 (PDT)
Message-ID: <04a0c48d-e81f-264a-b467-4a5b3ffc4f9c@opensource.wdc.com>
Date:   Fri, 15 Apr 2022 08:41:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
 <202204141624.6689D6B@keescook>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <202204141624.6689D6B@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/22 08:27, Kees Cook wrote:
> On Thu, Apr 14, 2022 at 11:10:18AM +0200, Niklas Cassel wrote:
>> bFLT binaries are usually created using elf2flt.
>> [...]
>=20
> Hm, something in the chain broke DKIM, but I can't see what:
>=20
>   =E2=9C=97 [PATCH v2] binfmt_flat: do not stop relocating GOT entries =
prematurely on riscv
>     =E2=9C=97 BADSIG: DKIM/wdc.com

Hu... WDC emails are not spams :)
No clue what is going on here. I can check with our IT if they changed
something though.

>=20
> Konstantin, do you have a process for debugging these? I don't see the
> "normal" stuff that breaks DKIM (i.e. a trailing mailing list footer, e=
tc)
>=20


--=20
Damien Le Moal
Western Digital Research
