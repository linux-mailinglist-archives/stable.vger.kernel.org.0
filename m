Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDBE4B8706
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 12:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbiBPLrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 06:47:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiBPLrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 06:47:40 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Feb 2022 03:47:26 PST
Received: from esa2.hc3370-68.iphmx.com (esa2.hc3370-68.iphmx.com [216.71.145.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF152982C;
        Wed, 16 Feb 2022 03:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1645012046;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hs21Wh2cM7/Vss8/5/xzVqPsipS2fZ/HWpoyJLtSF3E=;
  b=Vo4nmtI2WABuMqe0gDmO+3GfzPcD8sA9CZ4HBjgPdDGYW440DqxkUGtq
   YI8VBhPCs4UdirxS9LdarBG527GglDOv1MPO7UjIzkimQnz21dZh8gK9O
   sAKGMmOLcn31jvml7qou1Kq360PWCwnZoX4AKB8ZXuvyM4/qsxZ8haBEj
   w=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: DZkgyH1VnX/pdIGQWTeBPieQzVwrSINmDeIVW6fnZkHS1YFFLKnXo3HiVxEL2oZRkQSpUilx1S
 BsLoJjh4lxvahsD5H5A/YOJwsqswBsIxLEiEy28wUnnY9kIvmMOZD3bR+Ol8DnKV7iRfwGbcGO
 6Y8OxGm4keA4MAHvJH8t+K6B4i2yW6yIj0gxma7rzn8TqJquTE7LdqaALuTp8fClSEwC+EV6Dg
 WmZ26oNnKpSel9HTp515cK7Hp0lx35am3201RYGbFqACaWFB6f8VU2qG8xEZuWJpdSDK+aDFYA
 gwzQ9//9l158gF76gEMWqLNy
X-SBRS: 5.1
X-MesageID: 64328665
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:r2fl7KskxNbs15bZ6VJnwK43cufnVIZYMUV32f8akzHdYApBsoF/q
 tZmKTqCOf2NYmSjc9hxOt/i8kJU68XUxoM3HAc/rSo2FngQ+JbJXdiXEBz9bniYRiHhoOOLz
 Cm8hv3odp1coqr0/0/1WlTZQP0VOZigHtIQMsadUsxKbVIiGHdJZS5LwbZj2NYy2IbhWmthh
 PupyyHhEA79s9JLGjp8B5Kr8HuDa9yr5Vv0FnRnDRx6lAe2e0s9VfrzFonoR5fMeaFGH/bSe
 gr25OrRElU1XfsaIojNfr7TKiXmS1NJVOSEoiI+t6OK2nCuqsGuu0qS2TV1hUp/0l20c95NJ
 Npli6accx4zO5P1quk7QgIHHw1hA7Fo9+qSSZS/mZT7I0zudnLtx7NlDV0sPJ1e8eFyaY1M3
 aVGcnZXNEnF3r/ohuLgIgVvrp1LwM3DFYUToHx/ixreCu4rW8vrSKTW/95Imjw3g6iiGN6AO
 5FDOWQxMXwsZTUXYgw5OL5ihN2qj2LDcXpTlHe1qaYOtj27IAtZj+G2bYu9lsaxbcFUmFuI4
 2HL5WL0BjkEO9GFjzmI6HShgqnIhyyTcJ4VEqz+8uNhg3WSwHAeDFsdUl7TifC6okq/Xc9Pb
 U0S5icq66M18SSDVcX0VRm1iGCLswRaWNdKFeA+rgaXxcL85QuUAmkBR3hCct09tMk/QxQr0
 EOEm5XiAjkHmLSTVXWb97DSojS3NDpTLGAGaDQFRBAt59jlvZF1jxTTQ9IlG6mw5vX1ATjY0
 SGWqzJ4jLIW5eYX2KGr1VTGhS+wvJ/PTx5z6gi/dmi9xgp9ZYOjN8qk5DDz9f9fJYDfTUSEt
 WJClNWG8OkmCZCLiTzLQeMREbXv7PGAWBXM0QBHHJQ78TmpvXm5cuh47DhgKQFpO8AfdDnBZ
 E7VpBMX5ZlPMX/sZqhyC6q0CsIlyoD6GNjlX+ySZd1LCqWdbyfeonsoPxTJmTmwzg58ysnTJ
 Kt3b+6SN1ogEL5i8gOESsEMyuAn6j8A2U3cEMWTIwuc7ZKSY3ucSLEgOVSIb/wk4K7snDg54
 +qzJOPRlUwBDbSWjj3/tNdKcAtUdSRT6YXe9pQPHtNvNDaKD43I5xX55bo6M7JokK1O/gsj1
 iHsAxQIoLYTaJCuFOlrVpyBQO63NXqchShiVcDJAbpO8yJ+CWpIxP1CH6bbhZF9qIReIQdcF
 pHpgfmoDPVVUSjg8D8Ad5T7p4EKXE312V7fYnP/MWluJsQIq+n1FjnMJFaHGM4mVHTfiCfDi
 +f4ilOzrWQrG2yO8/o6mNrwlgjs7BDxacp5XlfSI8k7Rakf2NMCFsAFtddue5tkAUyanlOyj
 l/KaT9F9bili9Jkq7Hh2PHbx7pF5sMjRyK26UGAtu3oXcQbl0L+qbJ9vBGgJ2CNDjilp//7O
 I24DZjUaZU6obqDiKIle55DxqMi/dr/4bhcywVvBnLQaFq3TLhnJxG7MQNn7MWhH5dV5lm7X
 Fyh4N5fNenbMc/pCgdJdgEkcv6CxbcfnTyLtaY5J0Dz5SlW+rubUBoNY0nQ2XIFdLYlYpk4x
 eoBudIN71DtgBQdLdvb3Dtf8H6BLyJcXvx/5I0aGoLiliEi1kpGPc7HEibz7ZzWM4dMP0AmL
 yW6nq3Hg7gAlEPOf2BqTSrG3PZHhIRIsxdPlQdQK1OMk9vDp/k2wBwOrmhnElULlk1KirshN
 HJqOkt5IbS10w1p3MUTDXqxHwxhBQGC/hCjwVU+i2CEHVKjUXbALTNhNL/VrlwZ6W9VYhNS4
 KqclDT+ST/vccz8gnkyVEpip6CxRNB97FSfysWuHsDDFJgmezv1xKSpYDNQ+RfgBMowgmzBp
 PVro7ksOfGqa3ZIrv1pEZSe2JQRVAuAdT5LTvxW9a8UGX3RJWOp0j+UJkHtIs5AKpQmK6Nj5
 xCC8i6XaymD6Q==
IronPort-HdrOrdr: A9a23:ImDKo6krFRD0vTfobfaKWGKZo6zpDfOKimdD5ihNYBxZY6Wkfp
 +V8sjzhCWatN9OYh0dcIi7SdW9qXO1z+8Q3WGIVY3SHTUOy1HYU72KirGSgwEIeheOuNK1sJ
 0AT0EQMqyJMbEXt7eZ3OD8Kadc/DDlytHquQ699QYXcegCUcgJhG0Vanf5LqQ1fng9OXNQLu
 vA2iMtnUvGRZ1jVLXDOpBzZZmkmzSkruOCXTc2QzocrCWehzKh77D3VzKC2A0Fbj9JybA+tU
 DYjg3Q/MyYwrOG4y6Z81WWw4VdmdPnxNcGLteLkNIpJjLljRvtTJh9WoeFoCs+rIiUmRMXeZ
 j30lMd1vZImjXsl1KO0ELQMs7boW4TAkrZuBilaL3Y0JfErXwBepB8bMliA2XkAgIbzaBBOe
 Rwrj6kXtNsfGD9dG6W3am5azh60kWzunYsiugVkjhWVpYfcqZYqcgF8FpSC4poJlO21GkLKp
 gkMCjn3ocdTbpaVQGvgkB/hNi3GngjFBaPRUYP/sSTzjhNhXh8i08V3tYWkHsM/I80D8As3Z
 WKDo140LVVCsMGZ6N0A+kMBcOxF2zWWBrJdGafO07uGq0LM2/E75T3/LI27ue3f4Fg9up/pL
 3RFFdD8WIicUPnDsODmJVN7xDWWW24GS/gz8lPjqIJ8oEUhICbeBFrZGpe5vdIks9vdPEzAc
 zDSq6+K8WTWVfTJQ==
X-IronPort-AV: E=Sophos;i="5.88,373,1635220800"; 
   d="scan'208";a="64328665"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLSuWlJOM4+tMZyoUi8VUAZTY+KwFUX9ZvCcb48PzHcuk5qi5fC7piOSn0BOUkVn+w13ke/jIEkARi9aZc5iOJ9YH67mJkEH3u7bmU6cFlbNGigzi57lpNwtgf1TH3mEvCGI6aVigSF6xbvE4mw3FTl1B3OqWv9RR2GUluDPzDZoIo8EHblNHccL5+coNZ31a9StJw3eSfNwc7dcbK+Qs8OsxTxIMDogaxDg3/kgKEs4yweAkRcDFSEhXmyfzAvAs7aRdY7t64n9LydjCfMo8TVqyjt/TiHjxeVFysNfdqyItLRS5s9r7QdcZR44ZMpenpoz52quoYiCIyPbC1TgcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hs21Wh2cM7/Vss8/5/xzVqPsipS2fZ/HWpoyJLtSF3E=;
 b=NC37Yuw5A9A0tegQcoTWNFA9NJ0nqOf5H0Vd8X6tic2wi/W49b9WdK7XazquPrPGdRKL/GWlf8I3Cbp6KppKkP8eNP6BEL/DR63k4StS51l+YeO5JAjU0bUIcYRHQFM1Z3pkOOLYg34JjsIb10yJw17dxQD3+oI4DOiql+oc2zwsw9H9MzDTkUEtdlxqt7Kke2utzTMJMIzR3VwvqOEe9E4tmjs+j1TSSsPOxJWLMPL1sAKy8tBvmk32AVEiui2vmTvOojt0jJK9D2gGYdi7ikIMHuWICiK4PrkanYP0VEB1WsQSz8hoSB8GDR4kcuXl4nhrN39r/+yWIFa3hBrLAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hs21Wh2cM7/Vss8/5/xzVqPsipS2fZ/HWpoyJLtSF3E=;
 b=daTIoxRB1N4KEyrqqL6x43lxHh4KPuVE1NDpV4sjARWohjPobh2vNbTQmJXSqDYD2aYAeVSv+o2yRihwJxGAeqMJQOlcaUnPGDxoH/rHidWSe10TFNMdxd4l3ngY8ut2LY1URXZwdTzK0D/xJ94AE7Drj8lBfIcdm4HIAZZPxbc=
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Andi Kleen" <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "antonio.gomez.iglesias@linux.intel.com" 
        <antonio.gomez.iglesias@linux.intel.com>,
        "neelima.krishnan@intel.com" <neelima.krishnan@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Thread-Topic: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Thread-Index: AQHYIomkaZpoY39Ru0mq/0xDtsSYzayU7BOAgAAUwoCAAFWAAIAAApUAgAALEYCAAKyPgA==
Date:   Wed, 16 Feb 2022 11:46:17 +0000
Message-ID: <a1e836c5-e2d0-3916-ec11-9f8690463c58@citrix.com>
References: <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
 <YgrltbToK8+tG2qK@zn.tnic>
 <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
 <Ygt/QSTSMlUJnzFS@zn.tnic>
 <20220215121103.vhb2lpoygxn3xywy@guptapa-mobl1.amr.corp.intel.com>
 <YgvVcdpmFCCn20A7@zn.tnic>
 <20220215181931.wxfsn2a3npg7xmi2@guptapa-mobl1.amr.corp.intel.com>
 <YgwAHU7gCnik8Kv6@zn.tnic>
 <20220216003950.5jxecuf773g2kuwl@guptapa-mobl1.amr.corp.intel.com>
 <6724088f-c7cf-da92-e894-d8970f13bf1e@citrix.com>
 <20220216012841.vxlnugre2j4pczp7@guptapa-mobl1.amr.corp.intel.com>
In-Reply-To: <20220216012841.vxlnugre2j4pczp7@guptapa-mobl1.amr.corp.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 862e6be6-ea92-491e-d45b-08d9f141f16c
x-ms-traffictypediagnostic: MW4PR03MB6457:EE_
x-microsoft-antispam-prvs: <MW4PR03MB6457A35EFB2E93361CCB62BABA359@MW4PR03MB6457.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:561;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KMo3T9TmLLA9edpGNNr0xsVIjEdbCEZelgX4eeDbB2BZLZE52lIPc/ACFobsaWpZSthTtoezW08gfY0up39EejDrzXFXSWi6vqDB3BAdeoFmY/E9rE/fOHUaZxMYq0QY0uVJA1FhfJmtuvKIl79FywJn6MtxkiEUADkFfJQkRHMrnOGGqZ5pUpNg/lyMkw3DkuWyTjK+4aDnVwkXP3hO3p6LhUXs1oScR0S/sgugFh4NoHHgNkJIN4Yjc2gB3aV94/p0QM7LOu3hzyWzZfgDLTFMvxNFH8ooED7HdL09Duyw2ktAYww3vc+jwxohJrcDhqMjCM4Y6IKes/LuQM84PVF/UR0XMwFfg0kRMe0eSDp5iu9r4p7tpzJTs5stegZ9uOxQQdDcpOTlIU1F60w91kx3vZQySmg7uj+GT/hmKU8qNYID831FleKLQolaFR9Lyx40K6DtIv7e7sE59+ai7Tr9hLlPK/5T7ybOkDhBAmbI9AgWGQeM22sqVTxVwt44laD8ZyzqOmau4gFOZFz4KivsfnjAP/KurECrEbBkwUa0cXRdPoJrgc6M+0EvzwYq/bUZE2DaQsqWKxgTszsnVC4fyCyDCoX9OYbiELaU429QTyjljtGIECL62slj80AIo84DLx7J1qodkgyuMlpLynKf86FAKAiZCEn9NBnyRFJoicck9fRz0TVXwi56NvFSjsFUdJya1GvUQ7yGoB3Bhx7fAV0WX7dtAVtjj1CsGvoHGUhhAbB86blGHZ3c4Izyyi7NPorFk/RuDcv9HHKcnemfmCDeKKNo4ZfxxO0MAsU4foPXgnk5vZs5uHPO+faEGS1T5R7J/M+LlmOFWnAL2Hhmnc8ki6s7JJ3F5zQXHzo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(8936002)(82960400001)(38070700005)(54906003)(38100700002)(122000001)(64756008)(8676002)(66476007)(66446008)(91956017)(4326008)(66556008)(66946007)(76116006)(6506007)(2906002)(2616005)(86362001)(966005)(6486002)(316002)(6512007)(31696002)(31686004)(508600001)(26005)(186003)(5660300002)(6916009)(53546011)(83380400001)(7416002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dEVGZnNnSzdhRzVNWnBGdld6RFpzbTdvNldtN2hmbmZWOU0rNHFNb2kycTBi?=
 =?utf-8?B?ZmV5SDZoQVpUb2dqN3ZLdXZ2ejNQb05IdFpSSWxGRDRFTjgvT3ZobEptNHBn?=
 =?utf-8?B?M1lIWmo3Z2llVlp1NVhMWU5ZRjJSaFZIOHYxT3hqc0VDNkFLN3hLY3JYckdw?=
 =?utf-8?B?SEdGeCt2djR6aFJNb1lGdHljekpOS3RiK3E3U29BZnA0S3Uzb2xROVdqQmdo?=
 =?utf-8?B?K3NHc3R1ZVY3d3BnRStRSytlRXdXamNueVBFMjVrWGwvYm5Ba3RUd0FEUlRM?=
 =?utf-8?B?VzR3Mk5GUm5MZWhiN2crRkxjWlI3VkE3aUM1ZTZTNlJTVENSUGJWQU5GNExJ?=
 =?utf-8?B?TFNpaUJaM1drYWJtQXpFelFsSEVPSjRWTXpvVkxMSjBPcktibUY0TlJteEVY?=
 =?utf-8?B?ZG5LMUxnZTZ0MldnNG04TWR3Q3RlM2tJZXFQa3dTb1FseDRpajdJZjdGMUJS?=
 =?utf-8?B?S0Juc3NBV29rd2R2dFkwbU8vMVRQL0x0YjVHc0w5ZTd4cmFoTnhvcTh6NU5p?=
 =?utf-8?B?Y0RwTGxxVUw0RFpaUXRlNjhsN3RXUmt5OVdlQUN0NVJrbVV1c2cxUUpKeGgv?=
 =?utf-8?B?UGF2cFFlMzlCclYyNm81T1RYTjV2bWI1UU54TEdabkFZbit3Wlp5MlRWVFc4?=
 =?utf-8?B?Z3VuSWFxelVtTXpSSXBrRFdvTCs4cmJJSlY3QkZXS1I1NWVMcnJ1LzNZYXFN?=
 =?utf-8?B?QmVQcUJiQXlqelNCU1AxNUJBdkF6RWdySk5hWU9Jd0RPNFNpdGVoZU9jUm1u?=
 =?utf-8?B?Ukp0MWVydVdUNUNGMUgwcUp4Ylp4TmNwNTFTaEpNR1p2bEozZmthaHo5Uk5T?=
 =?utf-8?B?dSs4djNMc1F3dCtWKzBtWlFRcmFGQnhkME5yOUhheG1kalQ1ZWJsTmdXK21u?=
 =?utf-8?B?cUdkeVoveVhTaHk0UmdRSUdQeEFEd25pU0Q2SGtjcmV0U2RZeCtDV25MbHVX?=
 =?utf-8?B?SmVUSUwwZ1lJR040RlRkTmQvYnhiVVlGUDBLWWJRMEVaVnNsSmhGdzFqdnkw?=
 =?utf-8?B?cHBZZ1ZaZWJSMFNKZzZncmJQQ3hDMi85UTBrRzZKcTl0Mndsbk9vdStNZGZ4?=
 =?utf-8?B?K0czekVOOTMyeXoxZk1LTnJuTlpsdU1vOVBnVEx2QmZBU05jbUk4aFRLcUhF?=
 =?utf-8?B?c3VNYlAyN25haU1HdENFT2Z6VWFrQTcwU05WaUFBQ3pLSW80bHBrS1dDM2dJ?=
 =?utf-8?B?WlM4QVRwelYvSGFleVFGVEZVMDdZbno4NmI3TEhwMWRwOWthM01yWW9KMUFL?=
 =?utf-8?B?eVRCYTFDaXdIQW1QdUczTTIycUN1dkV5T0N0YW9KTEczUzZvMEJITWRsK21w?=
 =?utf-8?B?aHZuWDdzTVUxZzZFNk8wZ2FVOFU2Tk8yUkFxeUFDa2hvVU85V2JQU0x2RVBk?=
 =?utf-8?B?aTdONzZzdHl0UTBSN1NSNkV5cVZCclJQQjc2TkMyODhSM2RKY0J1SGdnYUtT?=
 =?utf-8?B?QUNGQThjcitPN2QvbWM3K3dpaGcvQ3piT2hha2d2MnNQd0E0QmJkV1VWMW5T?=
 =?utf-8?B?Y0U2ZHdNNXl4ZUROcEY3QXBrTkxXNENlZzFWVlBjMnlxM1NhRXlBN1RuOXcv?=
 =?utf-8?B?TU5qQUNsVWlxQnZsbGxyZ3VVR25rSEpYWkQ0N3JhRFBsNzlrRDc2ems3cldz?=
 =?utf-8?B?SWtjVmFBWldyUTUwclFsZVFDNzNKUjA3cEZab3MyVXdmak9oV2VTSVdydzZE?=
 =?utf-8?B?dXQxKzcxSTJtM2pjdC9ZaFBjbDBlSWFsc1dZczBrdnZDNzV2bzZhTWlDWnd6?=
 =?utf-8?B?bW1nRndyVUROTmUzbnp0L2tlRHlXTm92VzFkYVg3RDV6RDBZMG13Q0dEakR5?=
 =?utf-8?B?N1B4b1lKL0dZbW5XS0dIdkREUUFrQmlYVnBEb3ZEc2tBNGdxNGRKZTUvNXBt?=
 =?utf-8?B?MjV0aUlleUJ0N0gvQmIxd1M0MDRBTjI1Wk9jbHZDZmZIY3E1TTZQTGpsRWxX?=
 =?utf-8?B?Nm5uVGNkNGV1dWNyY1F2aG1xdmJzcklLbzRNOTFYQy9lSWZrUGIvdklnQktx?=
 =?utf-8?B?S2wyV2o3eVJvenFhYXRQbGQ2MHNYVjNTbXNhOTBpYkNLaks4a0xTNUsxZnBE?=
 =?utf-8?B?U04rS0xwWXJvMDNqYVF0ZmpQaHl6Z1ZFZEZwM2EveDFuOWh4by9vdDNMRjNs?=
 =?utf-8?B?Wk1kTjNJNkRGQkIxc0NxNndmczlJZ1VydFF2aUZhQlNMM2xQQUtIN0k3SXk2?=
 =?utf-8?B?QzMraEw2OWZKQ0RkeG9JaEZtaGU3Wk5BMlhrbVNBb3BiekwweEdZLzJ1SVZz?=
 =?utf-8?B?eGk4cnI0bzlaVENsTVFGZy9NOVR3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B7C5A89690CCC49B540F0DD1B5C524D@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 862e6be6-ea92-491e-d45b-08d9f141f16c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 11:46:17.3995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hmcwpY2bjd3zD/wYmCLd2a2BBxLdNSGpTfayOsOKEgNGCimqtMBpd0RTUB1CLAbIBTyWRHK4cmDN+bzOhxZ593zqXKGNUWEqZ0O4jIzpUcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR03MB6457
X-OriginatorOrg: citrix.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTYvMDIvMjAyMiAwMToyOCwgUGF3YW4gR3VwdGEgd3JvdGU6DQo+IE9uIDE2LjAyLjIwMjIg
MDA6NDksIEFuZHJldyBDb29wZXIgd3JvdGU6DQo+PiBPbiAxNi8wMi8yMDIyIDAwOjM5LCBQYXdh
biBHdXB0YSB3cm90ZToNCj4+PiBPbiAxNS4wMi4yMDIyIDIwOjMzLCBCb3Jpc2xhdiBQZXRrb3Yg
d3JvdGU6DQo+Pj4+IE9uIFR1ZSwgRmViIDE1LCAyMDIyIGF0IDEwOjE5OjMxQU0gLTA4MDAsIFBh
d2FuIEd1cHRhIHdyb3RlOg0KPj4+Pj4gSSBhZG1pdCBpdCBoYXMgZ290dGVuIGNvbXBsaWNhdGVk
IHdpdGggc28gbWFueSBiaXRzIGFzc29jaWF0ZWQgd2l0aA0KPj4+Pj4gVFNYLg0KPj4+Pg0KPj4+
PiBZYWgsIGFuZCBsb29rYSBoZXJlOg0KPj4+Pg0KPj4+PiBodHRwczovL2dpdGh1Yi5jb20vYW5k
eWhocC94ZW4vY29tbWl0L2FkOWY3YzNiMmUwZGYzOGFkNmQ1NGY0NzY5ZDRkY2NmNzY1ZmJjZWUN
Cj4+Pj4NCj4+Pj4NCj4+Pj4NCj4+Pj4gSXQgc2VlbXMgaXQgaXNuJ3QgY29tcGxpY2F0ZWQgZW5v
dWdoLiA7LVwNCj4+Pj4NCj4+Pj4gQW5keSBqdXN0IG1hZGUgbWUgYXdhcmUgb2YgdGhpcyB0aGlu
ZyB3aGVyZSB5b3UgZ3V5cyBoYXZlIGFkZGVkIGEgbmV3DQo+Pj4+IE1TUiBiaXQ6DQo+Pj4+DQo+
Pj4+IE1TUl9NQ1VfT1BUX0NUUkxbMV0gd2hpY2ggaXMgY2FsbGVkIHNvbWV0aGluZyBsaWtlDQo+
Pj4+IE1DVV9PUFRfQ1RSTF9SVE1fQUxMT1cgb3Igc28uDQo+Pj4NCj4+PiBSVE1fQUxMT1cgYml0
IHdhcyBhZGRlZCB0byBNU1JfTUNVX09QVF9DVFJMLCBidXQgaXRzIG5vdCBzZXQgYnkNCj4+PiBk
ZWZhdWx0LA0KPj4+IGFuZCBpdCBpcyAqbm90KiByZWNvbW1lbmRlZCB0byBiZSB1c2VkIGluIHBy
b2R1Y3Rpb24gZGVwbG95bWVudHMgWzFdOg0KPj4+DQo+Pj4gwqAgQWx0aG91Z2ggTVNSIDB4MTIy
IChUU1hfQ1RSTCkgYW5kIE1TUiAweDEyMyAoSUEzMl9NQ1VfT1BUX0NUUkwpDQo+Pj4gY2FuIGJl
DQo+Pj4gwqAgdXNlZCB0byByZWVuYWJsZSBJbnRlbCBUU1ggZm9yIGRldmVsb3BtZW50LCBkb2lu
ZyBzbyBpcyBub3QNCj4+PiByZWNvbW1lbmRlZA0KPj4+IMKgIGZvciBwcm9kdWN0aW9uIGRlcGxv
eW1lbnRzLiBJbiBwYXJ0aWN1bGFyLCBhcHBseWluZyBNRF9DTEVBUiBmbG93cw0KPj4+IGZvcg0K
Pj4+IMKgIG1pdGlnYXRpb24gb2YgdGhlIEludGVsIFRTWCBBc3luY2hyb25vdXMgQWJvcnQgKFRB
QSkgdHJhbnNpZW50DQo+Pj4gZXhlY3V0aW9uDQo+Pj4gwqAgYXR0YWNrIG1heSBub3QgYmUgZWZm
ZWN0aXZlIG9uIHRoZXNlIHByb2Nlc3NvcnMgd2hlbiBJbnRlbCBUU1ggaXMNCj4+PiDCoCBlbmFi
bGVkIHdpdGggdXBkYXRlZCBtaWNyb2NvZGUuIFRoZSBwcm9jZXNzb3JzIGNvbnRpbnVlIHRvIGJl
DQo+Pj4gbWl0aWdhdGVkDQo+Pj4gwqAgYWdhaW5zdCBUQUEgd2hlbiBJbnRlbCBUU1ggaXMgZGlz
YWJsZWQuDQo+Pg0KPj4gVGhlIHB1cnBvc2Ugb2Ygc2V0dGluZyBSVE1fQUxMT1cgaXNuJ3QgdG8g
ZW5hYmxlIFRTWCBwZXIgc2F5Lg0KPj4NCj4+IFRoZSBwdXJwb3NlIGlzIHRvIG1ha2UgTVNSX1RT
WF9DVFJMLlJUTV9ESVNBQkxFIGJlaGF2ZXMgY29uc2lzdGVudGx5IG9uDQo+PiBhbGwgaGFyZHdh
cmUsIHdoaWNoIHJlZHVjZXMgdGhlIGNvbXBsZXhpdHkgYW5kIGludmFzaXZlbmVzcyBvZiBkZWFs
aW5nDQo+PiB3aXRoIHRoaXMgc3BlY2lhbCBjYXNlLCBiZWNhdXNlIHRoZSBUQUEgd29ya2Fyb3Vu
ZCB3aWxsIHN0aWxsIHR1cm4gVFNYDQo+PiBvZmYgYnkgZGVmYXVsdC4NCj4+DQo+PiBUaGUgY29u
ZmlndXJhdGlvbiB5b3UgZG9uJ3Qgd2FudCB0byBiZSBydW5uaW5nIHdpdGggaXMgUlRNX0FMTE9X
ICYmDQo+PiAhUlRNX0RJU0FCTEUsIGJlY2F1c2UgdGhhdCBpcyAic3RpbGwgdnVsbmVyYWJsZSB0
byBUU1ggQXN5bmMgQWJvcnQiLg0KPg0KPiBJIGFtIG5vdCBzdXJlIGhvdyBhIHN5c3RlbSBjYW4g
ZW5kIHVwIHdpdGggUlRNX0FMTE9XICYmICFSVE1fRElTQUJMRT8gSQ0KPiBoYXZlIG5vIHByb2Js
ZW0gdGFraW5nIGNhcmUgb2YgdGhpcyBjYXNlLCBJIGFtIGp1c3QgZGViYXRpbmcgd2h5IHdlIG5l
ZWQNCj4gaXQuDQoNCldlbGwgZm9yIG9uZSwgd2hlbiBMaW51eCBpcyBzdGFydGluZyB1cCBhcyB0
aGUga2V4ZWMgZW52aXJvbm1lbnQNCmZvbGxvd2luZyBYZW4uDQoNCllvdSdyZSBub3QgY29kaW5n
IGZvciAid2hhdCBsb2dpYyBzaG91bGQgZm9sbG93IGEgY2xlYW4gbWljcm9jb2RlDQpsb2FkIi7C
oCBZb3UncmUgY29kaW5nIGZvciAiaG93IHRvIHRha2UgdGhlIGFyYml0cmFyeSBzdGF0ZSB0aGF0
IG15DQpwcmVjZWRpbmcgZW52aXJvbm1lbnQgbGVmdCwgYW5kIHR1cm4gaXQgaW50byB3aGF0IEkg
d2FudCIuDQoNCkxvb2sgbm8gZnVydGhlciB0aGFuIGxpbnV4Ym9vdCBmb3IgYW4gZW52aXJvbm1l
bnQgd2hlcmUgeW91ciBib290bG9hZGVyDQpoYXMgYWxyZWFkeSBhbHRlcmVkIHRoZXNlIHNldHRp
bmdzLg0KDQp+QW5kcmV3DQo=
