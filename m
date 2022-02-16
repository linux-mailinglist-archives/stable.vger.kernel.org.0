Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5934B7C1D
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 01:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245125AbiBPAu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 19:50:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243059AbiBPAuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 19:50:25 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 16:50:14 PST
Received: from esa5.hc3370-68.iphmx.com (esa5.hc3370-68.iphmx.com [216.71.155.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD1DF94E9;
        Tue, 15 Feb 2022 16:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1644972614;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZsGJz/zqeFW0kApse61TcbMPkh/45bVmYyMkERKTPEE=;
  b=ZSREe99zXiSGbMa6rY1bdO0wekpKiSTPGcPITjIvBvxlt07kmBqn97OI
   NHsiKvwl6W+IoDGUihUNFJHaMwL/KbpRpHob3K1sBoVWlRTS0kgNy3bfJ
   HVVHyQDkASTD2OQWCn7CQDT7Uq4Ezor50o+FFyOsZfFXYokF6DSNZpzTs
   0=;
Authentication-Results: esa5.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: 8kkKpt5ZsLUJgbkyVuD3DJzzrw7aAfAqzd+2bRMS74gree4/ngESAkJI4EsDcjQiw16Muz7YA6
 nV59FkVNz/f1NXU5DED1kl5aUHKRoAnZtf+qr/SgQN49VzfO/ojTEuBRIJG/uac0sXN688Q2uw
 Wdx1hj1FN8ToK9xv0sF+jWTfhpWI35S4PSXgq8tv+h3eFV8m8M/GRrPquraPftvWlkUQ46QSTf
 NcUHbgeze5isqbBHfcSp2KkQXf7dfN6DroDepuw03VUcFdbb8UApqJN9uabt/IlzMMst+hzSDk
 LWomSzqm0m/ERSieARd7p7oD
X-SBRS: 5.1
X-MesageID: 63741857
X-Ironport-Server: esa5.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:o5/gQKp+frsd1+exdF1zM5rf8uxeBmLIYxIvgKrLsJaIsI4StFCzt
 garIBnQaK6OMWL2f4x2b4rk9RlUup6Hy9QxQQY9pHtkEnhB9ZuZCYyVIHmrMnLJJKUvbq7GA
 +byyDXkBJppJpMJjk71atANlZT4vE2xbuKU5NTsY0idfic5Dndx4f5fs7Rh2NQw24HkW1/lV
 e7a+KUzBnf0g1aYDUpMg06zgEsHUCPa4W5wUvQWPJinjXeG/5UnJMt3yZKZdhMUdrJ8DO+iL
 9sv+Znilo/vE7XBPfv++lrzWhVirrc/pmFigFIOM0SpqkAqSiDfTs/XnRfTAKtao2zhojx/9
 DlCnY2rUA0uGbXso7o6UR9KQ39bAYtUoqCSdBBTseTLp6HHW37lwvEoB0AqJ4wIvO1wBAmi9
 9RBdmpLNErawbvrnvTrEYGAhex6RCXvFKoZtmtt0nfyCvE+TIqYa67L+cVZzHE7gcUm8fP2O
 ZFGNWM/MUuojxtnJ1AIN8gRgNqSp3TNWj5W8nKz+/sF7D2GpOB2+Oe0a4eEEjCQfu1Rn0CFt
 ifF8n7/DxUyKtOS03yG/2iqi+uJmjn0MKoOE7upsPp3i167x2oPBRlQXly+ydGwiWa6WtRCO
 woV/DYjqe4580nDZsLhVhe8rVaasRMGHdldCes37EeK0KW8ywCUC2wFSzcHa8Ynr88wTDoC1
 1mVktevDjtq2JWcT26a8LaT6zy1PCUHa24NYSIfTAIey93ippwjyBPJUttnVqWyi7XdGSn56
 yKbsC8kwb4UiKYjy6q/7XjDgjSxuoLOSA8loAnaNkqv9itwYI+oYdzu5VWzxe5JM4+fCFqcu
 XEe3ceD9PwHJZWMkjGdBuQLALytof2CNVX0kQ4xN5os7TKg/zikZ484yD13OkovMs8CYjLvS
 EvSvx5Bop5VIHauK6RwZuqZDsUswq/ID9npVvnIKNFJZ/BMmBSvpX80IxTKhia0zRZqwfpX1
 YqnndiEHG0DA6NA1BqNGcAf1617mAUC43GJWsWup/i46oa2aHmQQLYDFVKBaOEl8a+JyDnoH
 8Zj29iikEsGDrCnCsXD2ctKdA1RcyBnbXzjg5EPLoa+zhxa9HbN4hM76ZcoYMRbkqtcjY8kF
 VntCxYDmDITaZAqQDhmi0yPipuyBf6TTlphZETA2GpEPVB5PO5DC49FKvMKkUEPrrAL8BKNZ
 6Btlz+8KvpOUC/b3D8WcIPwqodvHDzy217Sbnf8OmluLsc6L+AsxjMCVlGynMXpJnDp3fbSX
 pX6jl+LKXb9b1gK4DnqhAKHkArq4Cl1dBNaVErUONhDEHgAA6AxQxEdesQfeplWQT2an2Py/
 1/PXX8w+Lmcy6dooYKhrf3V8O+U/x5WQxMy85/ztu3ta0E3PwOLnOd9bQp/VWmGCj2toPz4P
 bo9IjOVGKRvoWumerFUSt5D5ak/+8Hut/ldyAFlF2/MdFOlFvVrJXzu4CWFnvQlKmZxtVTkV
 0SR1MNdPLnVasrpHERIfFgub/iZ1OFSkT7XtKxnLEL/7S5x3byGTUQNYEXc1H0DdON4YNE/3
 OMsmM8K8Ajj2BAkBcmL03JP/GOWI31eD6h+7sMGAJXmgxYAw01ZZcCOETf/5ZyCMo0eMkQjL
 jKOqrDFgrBQmhjLf3YpTCCf1utBn5Ue/htNyQZadViOn9PEgN4x3QFQrmtrHlgEkE0f3rsqa
 GZxNkBzKaGfxBtShZBODzK2BgVMJByF4UitmVEHo3LUEhuzXWvXIWxjZevUpBIF83hRdyRw9
 a2DzDq3Si7jecz803dgWUNhrPC/H9V9+hebxZKiFsWBWZI7fSDkkumlYm9R80nrBsY4hUvmo
 +h2/bkvNf2nZHBI+6BrWZOH0bkwSQyfID0QSP5sy6oFAGXAdWzgwjOJMU2wJptAKvGiHZVU0
 CCyyhajjyiD6Rs=
IronPort-HdrOrdr: A9a23:BvUWKKPORwb6esBcT2X155DYdb4zR+YMi2TDiHofdfUFSKClfp
 6V8cjzjSWE9Qr4WBkb6LW90DHpewKTyXcH2/hsAV7EZnimhILIFvAs0WKG+VPd8kLFh5dgPM
 tbAstD4ZjLfCJHZKXBkUmF+rQbsaG6GcmT7I+0pRYMcegpUdAa0+4QMHfALqQcfngjOXNNLu
 v72iMxnUvGRZ14VLXYOlA1G8z44/HbnpPvZhALQzQ97hOVsD+u4LnmVzCFwxY3SVp0sPQf2F
 mAtza8yrSosvm9xBOZ/XTU9Y5qlNzozcYGLNCQi/ISNi7nhm+TFcZcsvy5zXUISdOUmREXee
 r30lEd1gNImirsl1SO0F/QMs/boW4TAjHZuASlaDDY0LPErXoBerR8bMRiA0bkAgMbzaFBOO
 gg5RPpi7NHSRzHhyjz/N7OSlVjkVe1u2MrlaoJg2VYSpZ2Us4akWUzxjIcLH47JlOw1GnnKp
 gbMOjMoPJNNV+KZXHQuWdihNSqQ3QoBx+DBkwPoNac3TRalG1wixJw/r1Sol4QsJYmD5VU7e
 XNNapl0LlIU88NdKp4QOMMW9G+BGDBSQ/FdGiSPVPkHqcaPG+lke+73JwloOWxPJAYxpo7n5
 rMFFteqG4pYkrrTdaD2ZVamyq9CVlVnQ6dvP22y6IJyIEUdYCbRhFrEmpe4PdIi89vd/HmZw
 ==
X-IronPort-AV: E=Sophos;i="5.88,371,1635220800"; 
   d="scan'208";a="63741857"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7SE4XJZ9hs1Q/1VZ1IFNHIqs+pKEEyK7UnTTF324jkRDv0pMx7GKhR2u6w5RwmLsh6G2c1+iviRyoL2pGn4bVyAS65PWMSk1EuD/MTmULNQ7b11ESZjuH7GvvLbsROtxNncorMvKsUj56nrK+7txKQSwblCOomQtmZBz38Ztm91oR45dVYTJ/g6Z9a9JLoyJ4Ri6bqqKhF1iE005UzQtbOpCl0qDtFKbJO5Ns5UGptn9v2SWIj381eBzz9O8D35oS77HcF7naFfybKTNPuhZ5PKIvOpz/TSsVRlA/ls+Yd9SoZVoEMA50m03chzWu8zrJ2IhFoDtVkYPJ/fOIcBdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsGJz/zqeFW0kApse61TcbMPkh/45bVmYyMkERKTPEE=;
 b=PAJyvH7Ymvhgg7dGp2MkH8QJHgU7m6X7HB2SPGrWW9ejwzuCciOzG9gvhfV4++sBxdG1ZczQ++fL8zH5T+XQ45x4GXxFbceSas/i0au5IRtD6wI0IUuj2ixqXx9khTvEqiLCzwcFwUsUeljJdRHS4p7M4KiXueLO+XPmauXJt1aNdgDYI3VSIqOSq2GhgOAxH/n15KKN6uY8PtS7fu2M4EO2BjOPyizvONmBCtl8+x1dFSMN1PVJu/FPmXd5cQx8wrDMjwIjjM5+ZMHmWL8RMPfNNPY/RbpekWLUnG3NFwnbWHiy+lGnFhH/MZBTqvaArAW5ddXsx0foq3pBYLJwrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsGJz/zqeFW0kApse61TcbMPkh/45bVmYyMkERKTPEE=;
 b=owAh48HWG87bccfs2gK1LCw7dIJQW7WIvyTjP8NQ4g4kiOvsva8yj39zX/Uy0iR37TooEBcTmU/dCfgkHKh6fdAOhfelLBljnjCaZdQggY92UkKrnP/cImwqm9XqdhP3EeJcBE7rSicwAwi8QL3i9TsoxsgrUEd5cAXfU6hfbgI=
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "antonio.gomez.iglesias@linux.intel.com" 
        <antonio.gomez.iglesias@linux.intel.com>,
        "neelima.krishnan@intel.com" <neelima.krishnan@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Thread-Topic: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Thread-Index: AQHYIomkaZpoY39Ru0mq/0xDtsSYzayU7BOAgAAUwoCAAFWAAIAAApUA
Date:   Wed, 16 Feb 2022 00:49:05 +0000
Message-ID: <6724088f-c7cf-da92-e894-d8970f13bf1e@citrix.com>
References: <5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com>
 <YgqToxbGQluNHABF@zn.tnic>
 <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
 <YgrltbToK8+tG2qK@zn.tnic>
 <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
 <Ygt/QSTSMlUJnzFS@zn.tnic>
 <20220215121103.vhb2lpoygxn3xywy@guptapa-mobl1.amr.corp.intel.com>
 <YgvVcdpmFCCn20A7@zn.tnic>
 <20220215181931.wxfsn2a3npg7xmi2@guptapa-mobl1.amr.corp.intel.com>
 <YgwAHU7gCnik8Kv6@zn.tnic>
 <20220216003950.5jxecuf773g2kuwl@guptapa-mobl1.amr.corp.intel.com>
In-Reply-To: <20220216003950.5jxecuf773g2kuwl@guptapa-mobl1.amr.corp.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07504cec-9414-4c67-18da-08d9f0e621f5
x-ms-traffictypediagnostic: BN6PR03MB2964:EE_
x-microsoft-antispam-prvs: <BN6PR03MB2964507D7023D870A8064524BA359@BN6PR03MB2964.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +DKkL1GoWtH6wXpPi2Hq8NzcPUA9S9tr879+13FZeh8dPpMQQQC98oLsQo87dtXoQ86ywpQSe1f2GMJcg1k+xUn5BjpiH1byFtwb9ffEHFRNfxYzD7PxS/6QXtYCt6XljH73b7u3aJEqEwy7L2I/pZgMnDYhK2cFnO17vGTgvWEheGyOlmCROkjrOY2N4PAgQVGRb4ZeZCPIyTJmCzDZQ/36tgS7GE/T8dC19cFgxayGrIu0Q72R6NuwjZFgnHErzxLTrg3sbFP6rSjDyJB+AI6aAhrvME4hQfRp+P+jCQyfL0C9Q0JkE8lqGNOmOytv7b8IJL3xhwefpl389PmUXeCReT4umKbB9Tc5+HgHKgPlZDUUX3Oe1VDPXndqdivKxhMOIN7WgaTv+qDErBO1NJnzMTujI9LGf3UIFPL/wdB87qGOjdc4DDO371rWcxZTX0OXPOt+GD0erZE2f4PIgkV21vaJLN+0t3FgWDEdSkVGjfN2hG/3+df4JkpAyXqgFEKT4A88DHzoMESJ9wUqb9wrzoNQptDEhzRbg5b/rKFDXydUetXl/zRReSRaanbAWA2Ft37NxdHs6GTU3WTnrY4n3GDc3q/5YMR/FjDsOvFhIQNyrYcOpOOeb2foqQHYNpDgXiTU0voo5ZhfY5CQqNfY7Xzxb9n08NhHyh6kS20lEp5lymmeWxa9ZO0KYBJqFVR8FIAf+rhHv6mEZrlIbg0cOLTuvFpf+gyVmKHPjCi4F9TptUcIO3W+RDPHDdoOqEUrSIT/nMZG2cK1QlnnY9ULyJJIWUL0EVX6q4AFRox1N2x88qxAv75H/rnhIKxZ+rAdw6giMy8qN02oJaM5/Xh/BuUzfdF6YVQ6DQi3nUo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(316002)(53546011)(31696002)(64756008)(966005)(36756003)(66476007)(38070700005)(82960400001)(66446008)(8676002)(83380400001)(66556008)(4326008)(2906002)(86362001)(76116006)(122000001)(6506007)(6512007)(2616005)(508600001)(186003)(26005)(71200400001)(38100700002)(31686004)(7416002)(6486002)(91956017)(110136005)(54906003)(66946007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2RHR1hxL3VjU3lVYUxURFp3TG5iLytGTUgwaXFKMkVBczZpcTg3NngwcElC?=
 =?utf-8?B?RnNTb01tM0ZmQWxzQnRob2VuSlVkaWtKalRVZHFHL3Ria1BVOFo0RUVSUUlY?=
 =?utf-8?B?YVBYVkh4ejdjM3hXeEE3YVF6QUN0Q24vbWJ2YkNZeVY0Mms1ODNtcTU3Zk1G?=
 =?utf-8?B?MVBwOGtSeUxTaGMyRFdjUkYyamtqcVI2Rk12TmZsRkFxTnQzeGRDWnJZem9o?=
 =?utf-8?B?MDJyNDNVSEhsNFFoRGk4elNrd0RIZmFKek1scmY4L2VQSEpiNlFjeTdYYk05?=
 =?utf-8?B?SDFGbVc4Mm1UWGErT1YrRzRqOWY5YmJNQW5SRmMrRmZIbGNvMVBzazZhd2Jm?=
 =?utf-8?B?QkZmeHZDcHV6T0hLeFFJUjFiaktLdGNTWklEMm1EQkQ3SmYvVTlxV1BGTmVi?=
 =?utf-8?B?ZU95Kzk4Y1d5dzRQTUMzNGRxNTBkOEUrMHVsREhuMWNMRkUwYktLOVFDVDEv?=
 =?utf-8?B?RHVxNkZJRHBiQTVTZHhWMEZiS3N0RmRmU0Uxak8vOHFOUnFxbit3cTc0V0VX?=
 =?utf-8?B?WTI3YXl5Rlc5TTBJdDR5ckhYYnRNOG1rYVp4aTJDZXFEOG5KSHBtc0RoZFBt?=
 =?utf-8?B?NmtCeXN6NDh5b2RZektqa0VkN2F5akVYQnZDKytvcWd0TzlVUFN4OCtNQ2xm?=
 =?utf-8?B?UDVpd1JnSUJVRzVNczV1Z1BzYTlyWUlLN3Vqb3RWaFc1K1hUcisxRk8zR3Fq?=
 =?utf-8?B?K3FVNkdtWkpTYlZBVXVTcHZtb0t0eS8vUk1zTlRHQStzdlgzbnFRLzB6cUdL?=
 =?utf-8?B?dG5yc1pDeWtJRWh2cUNUOWZvWGFlTHUwNDNNMG53bGNsV0VwSEppQ1Foa3ZI?=
 =?utf-8?B?dFRxM3gxZEFScWtzeldFNmFSWEJHZlZXeHE4dTdCWVNoZGdxbzBrL256eWJI?=
 =?utf-8?B?YVJpUU43dU5UV2FwQ1dRTDZCVmp2a3BnZkYwZTBpOFpKYWNndGx2VmZzVDZT?=
 =?utf-8?B?aUxiQks3QUJwbkNnUjMySDBHMzdyc21leElpRklaSE9zMzZPMFVleEx4cVZW?=
 =?utf-8?B?OUpJcEV6RHIrZTVKQ1h1bkhiUVpvMlF1STE4SXRIc0hsc1NnSmJRdGIvYUFk?=
 =?utf-8?B?VXlYeEtFMEJ4YUd6RjFXalBqSzhrN1A4a0xHd0tsS3l5b0djS0FmcmxmZG9o?=
 =?utf-8?B?WkZvYjViSVlkZm9JL2E5ZDFsc21uOUcvRUlMN25rakJCYVgvUXJUUnJCcXBH?=
 =?utf-8?B?SGpwcDY3bkF3azBQRTlzVWxLek1WODFSZktLNVQ3ZjNIRVBkODZOSHUwRlVs?=
 =?utf-8?B?ODI4Qy93L1ZWekc2Wlp5T0o2RGhpTHNlbFYzT3d1YUZFaVZ2RTE2SElsS0Rp?=
 =?utf-8?B?OUszWm9Oa0pHc3Zoc0NyNE5LZVZkSEliYlVoUnBnUGQ4b2pHT2xOak96cHp4?=
 =?utf-8?B?ZEYrYlFkZ0crL2FzSWpHaXZ0cHl0Z29uVFRHdDluWWt6cTVrZ1pIY0xXUnQ2?=
 =?utf-8?B?NVZBbGlzMnBiMnNaUTVkUDFNMkFGNndiVWhBbGFyNllXQWlUYzBYVW8yb0hE?=
 =?utf-8?B?VGNwSERHRTBRQ043eVgwZVpOOWVCN1RZdjFvcEFpTGtwOTRSU21zbEYrQnJy?=
 =?utf-8?B?N1l2TmwzUGZYMDBVVTgvZXJPZWJZVjNqRHl0ZXJXMDNQLy9zM0Q4bEo0MzVy?=
 =?utf-8?B?OVA4VmNaZDRreURsMm05VnBpVUNLb2NjWW1lYUpxQmdKdWtGek5ScE9vbDYr?=
 =?utf-8?B?MUlUUVF3aGdLbnV1ZDJpTm5LYUFBeUpFYjlnd0ZpbnNWVS91Q2hsKzc4Wmhn?=
 =?utf-8?B?NzFmdFY0OHZaZERrOGk3WTJlbENEU2F5YXNuTm51aUtzNnpxSVNqVmRrQjhJ?=
 =?utf-8?B?bmsybFBEbG93c3ZOUDZmWE1DUEVwZkRMS2M4aVdRZzRVRFlWdlo2MExOOTZ6?=
 =?utf-8?B?dnV3eW5weVE0Z2VOQ0hNaldLS3FzZGUzeG43VEd1WnF5dTlhcEUyRWpZM2lO?=
 =?utf-8?B?bEsrLzBmOEtmWXFoSGo3d3N6Z3VZd0c5V3NBdm5jSHZ5c2cwUDhOVEdHRnJm?=
 =?utf-8?B?SEZPM3JjMGRFVTVjRjRRc3hkTjlRaU1UTERMbG9GSlV4bnYyUTd0d0lSMUxZ?=
 =?utf-8?B?bjB5d2RWNDRtQ2F0QnBWMEk1aUpWdzc3SWo4MGtnY28vcnVwM3Y2aktRalQr?=
 =?utf-8?B?VEhUVFJGVyswYkhYcElMOFJTL09GWDNRdUVZajhqVmdPNy9KRHo4ZXEvSmU0?=
 =?utf-8?B?bGw3TXRyZWgzczJtT3JLelN4NFVZSWhFanFZWWI4UTN4U1kyTllkMDlTRDV6?=
 =?utf-8?B?ZHdwdG1uWEE4Ti9KdnFMWjlDN3JnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE937346612BBD4EAA211AF3C36CD1FD@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07504cec-9414-4c67-18da-08d9f0e621f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 00:49:05.1553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RDiPGVxLxYClIDmhezy77sxFMm6ReRlDZCRnazylsKWFs+Avqk0TZgvnE0u1/juue8KGyvhmlbuv1b2IIbH/CpIuRXjarYg0DPzcGBPzmYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2964
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

T24gMTYvMDIvMjAyMiAwMDozOSwgUGF3YW4gR3VwdGEgd3JvdGU6DQo+IE9uIDE1LjAyLjIwMjIg
MjA6MzMsIEJvcmlzbGF2IFBldGtvdiB3cm90ZToNCj4+IE9uIFR1ZSwgRmViIDE1LCAyMDIyIGF0
IDEwOjE5OjMxQU0gLTA4MDAsIFBhd2FuIEd1cHRhIHdyb3RlOg0KPj4+IEkgYWRtaXQgaXQgaGFz
IGdvdHRlbiBjb21wbGljYXRlZCB3aXRoIHNvIG1hbnkgYml0cyBhc3NvY2lhdGVkIHdpdGgNCj4+
PiBUU1guDQo+Pg0KPj4gWWFoLCBhbmQgbG9va2EgaGVyZToNCj4+DQo+PiBodHRwczovL2dpdGh1
Yi5jb20vYW5keWhocC94ZW4vY29tbWl0L2FkOWY3YzNiMmUwZGYzOGFkNmQ1NGY0NzY5ZDRkY2Nm
NzY1ZmJjZWUNCj4+DQo+Pg0KPj4gSXQgc2VlbXMgaXQgaXNuJ3QgY29tcGxpY2F0ZWQgZW5vdWdo
LiA7LVwNCj4+DQo+PiBBbmR5IGp1c3QgbWFkZSBtZSBhd2FyZSBvZiB0aGlzIHRoaW5nIHdoZXJl
IHlvdSBndXlzIGhhdmUgYWRkZWQgYSBuZXcNCj4+IE1TUiBiaXQ6DQo+Pg0KPj4gTVNSX01DVV9P
UFRfQ1RSTFsxXSB3aGljaCBpcyBjYWxsZWQgc29tZXRoaW5nIGxpa2UNCj4+IE1DVV9PUFRfQ1RS
TF9SVE1fQUxMT1cgb3Igc28uDQo+DQo+IFJUTV9BTExPVyBiaXQgd2FzIGFkZGVkIHRvIE1TUl9N
Q1VfT1BUX0NUUkwsIGJ1dCBpdHMgbm90IHNldCBieSBkZWZhdWx0LA0KPiBhbmQgaXQgaXMgKm5v
dCogcmVjb21tZW5kZWQgdG8gYmUgdXNlZCBpbiBwcm9kdWN0aW9uIGRlcGxveW1lbnRzIFsxXToN
Cj4NCj4gwqAgQWx0aG91Z2ggTVNSIDB4MTIyIChUU1hfQ1RSTCkgYW5kIE1TUiAweDEyMyAoSUEz
Ml9NQ1VfT1BUX0NUUkwpIGNhbiBiZQ0KPiDCoCB1c2VkIHRvIHJlZW5hYmxlIEludGVsIFRTWCBm
b3IgZGV2ZWxvcG1lbnQsIGRvaW5nIHNvIGlzIG5vdCByZWNvbW1lbmRlZA0KPiDCoCBmb3IgcHJv
ZHVjdGlvbiBkZXBsb3ltZW50cy4gSW4gcGFydGljdWxhciwgYXBwbHlpbmcgTURfQ0xFQVIgZmxv
d3MgZm9yDQo+IMKgIG1pdGlnYXRpb24gb2YgdGhlIEludGVsIFRTWCBBc3luY2hyb25vdXMgQWJv
cnQgKFRBQSkgdHJhbnNpZW50DQo+IGV4ZWN1dGlvbg0KPiDCoCBhdHRhY2sgbWF5IG5vdCBiZSBl
ZmZlY3RpdmUgb24gdGhlc2UgcHJvY2Vzc29ycyB3aGVuIEludGVsIFRTWCBpcw0KPiDCoCBlbmFi
bGVkIHdpdGggdXBkYXRlZCBtaWNyb2NvZGUuIFRoZSBwcm9jZXNzb3JzIGNvbnRpbnVlIHRvIGJl
IG1pdGlnYXRlZA0KPiDCoCBhZ2FpbnN0IFRBQSB3aGVuIEludGVsIFRTWCBpcyBkaXNhYmxlZC4N
Cg0KVGhlIHB1cnBvc2Ugb2Ygc2V0dGluZyBSVE1fQUxMT1cgaXNuJ3QgdG8gZW5hYmxlIFRTWCBw
ZXIgc2F5Lg0KDQpUaGUgcHVycG9zZSBpcyB0byBtYWtlIE1TUl9UU1hfQ1RSTC5SVE1fRElTQUJM
RSBiZWhhdmVzIGNvbnNpc3RlbnRseSBvbg0KYWxsIGhhcmR3YXJlLCB3aGljaCByZWR1Y2VzIHRo
ZSBjb21wbGV4aXR5IGFuZCBpbnZhc2l2ZW5lc3Mgb2YgZGVhbGluZw0Kd2l0aCB0aGlzIHNwZWNp
YWwgY2FzZSwgYmVjYXVzZSB0aGUgVEFBIHdvcmthcm91bmQgd2lsbCBzdGlsbCB0dXJuIFRTWA0K
b2ZmIGJ5IGRlZmF1bHQuDQoNClRoZSBjb25maWd1cmF0aW9uIHlvdSBkb24ndCB3YW50IHRvIGJl
IHJ1bm5pbmcgd2l0aCBpcyBSVE1fQUxMT1cgJiYNCiFSVE1fRElTQUJMRSwgYmVjYXVzZSB0aGF0
IGlzICJzdGlsbCB2dWxuZXJhYmxlIHRvIFRTWCBBc3luYyBBYm9ydCIuDQoNCn5BbmRyZXcNCg==
