Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCFB643D45
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 07:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiLFGq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 01:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiLFGqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 01:46:47 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2187520984
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 22:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670309206; x=1701845206;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AzsErKObOeSdHVU0v+2ELRRiNknYBWmasc2TFqZExXk=;
  b=esyu4760liLhGlgVfRk0syJ3YfbsUGWRSISUGPHZOLoFDPwuig62xWbb
   JmbRNcjBrHkdvlTDn5wb2AXQP6HjPAY7G0u70d/BJyfg9df9XG5FdX7gX
   jwlajC3Gk6e+1eEpUmMKeGYX7vDwFJiviOytSnW88GINqN4DAkOIQHCkN
   Zs91POcT76M9+ywSM4LDnzhJV/JHv8dYWepE09FFFZ7B73rrGQDj5/SAx
   5GbXb5l1NOcSKiRb3p2svIuXcoaAzdZcR8WvVMuZjaroJ3uPH6RhljAK9
   /GTRmtNJrflQdHL85zsu1u9BCbVjhUun3e8Aak0bAD2WE0bKnqfXW8+Da
   w==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665417600"; 
   d="scan'208";a="217980028"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Dec 2022 14:46:44 +0800
IronPort-SDR: CksGZunurKITXLlmRWX54ThTlDahp3328KcfVAsxfO12NfRFnNJaLrzqI/IzZJiqWMbrrBp3ty
 1iTI9kYrbP01m5ywhrUj0RJic1ieSZZ20ciFLzMKKMkp+BBUCqRI34uuRLTpIjiwuOZv9Kr+lb
 gawxv8n9a910TpP59kqRGiWB9EqhG4oeBzGQwdcemSaNkFgIKLWfOZBRbCqI4/JbcafUufWn1X
 kdwVpEP1WzKhfVilFT0Xzqtzt0q7c3K1lcByEt0obXo9ixaHLKSgUpB5Oaq366TlrwMurCaNTY
 pzU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Dec 2022 21:59:31 -0800
IronPort-SDR: p36/bzhmZsG8TyJS+ZXX0ZnEwlqYGJ432i1R2l5dSGCEPoWnVxTim18eCJSzuTp3HBTBjhuFK4
 aJ6xi7Ro38QjIVohyszQbTfDYVWwlGNENLck8iT2/HhVpunqAGEeJ2JsPAANXsaiKsKtISSpWo
 3jUz3xh2EcL2t5iPY0JvsUdfHdx3y/WAQNjQ9H4b4fsfgrptynoNBJCbH84kH8KPsV5eh4+cNd
 y/uh/21f8aW0ZjZS6py7HRH26WucVjGrRLNbQl9uSDh47K6Gn6isZ3Lti5FmlvRLjcwiSCd/Gb
 5ws=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Dec 2022 22:46:44 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NR9tq4jcWz1Rwt8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 22:46:43 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670309203; x=1672901204; bh=AzsErKObOeSdHVU0v+2ELRRiNknYBWmasc2
        TFqZExXk=; b=ToAsBuCK/PENA44BfsRb20KSiuV+CTlW4XXIKhfKaTqz5sSxyF7
        4IOzmn99/HhKAvR8beodUTHLsyr66NRAj7EAWF1DS8xVT6IjCZiVzESnth+WOAVF
        l6RKzV/hKyRs83CpDYh1gJ35G/lXmZXwP506WkAcBJ8ztFB/CY9y02WTTHAQpnWe
        qtt/C+57StQvQf6c1Y4fje1cPSS2tfToOCQ6xh4hzGjyI6Yvp2uC01pBlmXa/7M2
        9N9z9bLwM7UWWEKZASVBQ7n81IsyY/yEwyDeX1q+4JAGzEQahHU8HczSrc46LpOU
        vc8nOE/9H+mDLQcRiuSgvxikYE71SzaIEOw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TyxH4KsjyaWQ for <stable@vger.kernel.org>;
        Mon,  5 Dec 2022 22:46:43 -0800 (PST)
Received: from [10.225.163.74] (unknown [10.225.163.74])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NR9tn5nrNz1RvLy;
        Mon,  5 Dec 2022 22:46:41 -0800 (PST)
Message-ID: <95785bc5-ac4b-9c44-74ea-6b3afb11cf14@opensource.wdc.com>
Date:   Tue, 6 Dec 2022 15:46:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] [v2] ata: ahci: fix enum constants for gcc-13
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Machado <luis.machado@arm.com>, linux-ide@vger.kernel.org,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
References: <20221203105425.180641-1-arnd@kernel.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221203105425.180641-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/3/22 19:54, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-13 slightly changes the type of constant expressions that are defined
> in an enum, which triggers a compile time sanity check in libata:
> 
> linux/drivers/ata/libahci.c: In function 'ahci_led_store':
> linux/include/linux/compiler_types.h:357:45: error: call to '__compiletime_assert_302' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
> 357 | _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> 
> The new behavior is that sizeof() returns the same value for the
> constant as it does for the enum type, which is generally more sensible
> and consistent.
> 
> The problem in libata is that it contains a single enum definition for
> lots of unrelated constants, some of which are large positive (unsigned)
> integers like 0xffffffff, while others like (1<<31) are interpreted as
> negative integers, and this forces the enum type to become 64 bit wide
> even though most constants would still fit into a signed 32-bit 'int'.
> 
> Fix this by changing the entire enum definition to use BIT(x) in place
> of (1<<x), which results in all values being seen as 'unsigned' and
> fitting into an unsigned 32-bit type.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107917
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107405
> Reported-by: Luis Machado <luis.machado@arm.com>
> Cc: linux-ide@vger.kernel.org
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: stable@vger.kernel.org
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied to for-6.2. Thanks !

-- 
Damien Le Moal
Western Digital Research

