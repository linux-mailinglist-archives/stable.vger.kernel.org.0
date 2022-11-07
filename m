Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B1761F7ED
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiKGPsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiKGPsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:48:08 -0500
Received: from esa6.hc3370-68.iphmx.com (esa6.hc3370-68.iphmx.com [216.71.155.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173C51F63A;
        Mon,  7 Nov 2022 07:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1667836087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+Jg55OzpMfPWRymYQUUDXx34g4bLUHS5e5Afb3Zf+Ws=;
  b=csqXcyuTvxsY5bdVrcWtKFT2oKONrSXOrpxU9UbbSKd/oq1INdH0y+OP
   urJqW6SbcZv/a5F85fuyVO/u+f92o/+1EQhfmXJ9oIXBr9VViecI7A2he
   5kHlN5Ie2MXY/L1btwPzfhEF8A0yiVRto19MX+lamf+SMT+i8PvtNy16p
   Q=;
X-IronPort-RemoteIP: 104.47.70.109
X-IronPort-MID: 83916859
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:+t2AA6jbGedJ4jURPdM8/qyfX1611xEKZh0ujC45NGQN5FlHY01je
 htvDDyHP/uOZTekKN1xOt629kJV68PczNJjHgFpqCs1EHgb9cadCdqndUqhZCn6wu8v7q5Ex
 55HNoSfdpBcolv0/ErF3m3J9CEkvU2wbuOgTrWCYmUpH1QMpB4J0XpLg/Q+jpNjne+3CgaMv
 cKai8DEMRqu1iUc3lg8sspvkzsy+qWs0N8klgZmP6oS5QeBzyN94K83fsldEVOpGuG4IcbiL
 wrz5OnR1n/U+R4rFuSknt7TGqHdauePVeQmoiM+t5mK2nCulARrukoIHKN0hXNsoyeIh7hMJ
 OBl7vRcf+uL0prkw4zxWzEAe8130DYvFLXveRBTuuTLp6HKnueFL1yDwyjaMKVBktubD12i+
 tQUGQoxXjODpNiE46D4EMVsip4/a9bCadZ3VnFIlVk1DN4AaLWaG+Dgw4Ad2z09wMdTAfzZe
 swVLyJ1awjNaAFOPVFRD48imOCvhT/0dDgwRFC9/PJrpTSMilMpluG1YbI5efTTLSlRtm+eq
 njL4CLSBRYCOcbE4TGE7mitlqnEmiaTtIc6RObpr6A63Qz7Kmo7JDFLeXaBvf6Cu22YdP1mC
 xUq9RoNlP1nnKCsZpynN/Gim1actBkaSdtWEsUg5Q2Nw7aS6AGcbkAATzhceJkludUwSDgCy
 FCEhZXqCCZpvbnTTmiSnp+XszaaJycYNykBaDUCQA9D5MPsyKk1hw7PR9BLE6OviNDxXzbqz
 FiisCg5grwIy8oG0amy9lPWqzupqt7CSQtdzh3aQm+//Ct4YoC/boCl4FSd6uxPRK6bS1Cdo
 GMDneCR6+cBCZzLnyuIKM0WEbiv5f2tPzrbjlpiWZIm8lyF4GKqd4RdyC9xKV0vMcsefzLtJ
 kjJtmtsCIR7OXKraep9Zd23AsFzlaz4T429B7bTc8ZEZYV3eEmf5iZyaEWM3mfr1k8xjaU4P
 pTdesGpZZoHNZlaIPONb791+dcWKuoWnAs/mbiTI8yb7Iej
IronPort-HdrOrdr: A9a23:scBNPa2zqtEiNxxESSOrYQqjBRFyeYIsimQD101hICG9Lfb0qy
 n+pp4mPEHP4wr5AEtQ4uxpOMG7MBDhHQYc2/hdAV7QZnidhILOFvAv0WKC+UyrJ8SazIJgPM
 hbAs9D4bHLbGSSyPyKmDVQcOxQj+VvkprY49s2pk0FJW4FV0gj1XYBNu/xKDwVeOAyP+tcKH
 Pq3Lsjm9PPQxQqR/X+IkNAc/nIptXNmp6jSwUBHQQb5A6Hii7twKLmEjCDty1uEg9n8PMHyy
 zoggb57qKsv7WQ0RnHzVLe6JxQhZ/I1sZDPsqRkcIYQw+cyjpAJb4RGIFqjgpF5d1H22xa1O
 UkZC1QePib3kmhPF1dZyGdnTUIngxeskMKgmXo/EcL6faJOA7STfAxy76xOyGplXbJ9rtHod
 129nPcuJxNARzamiPho9DOShFxj0Kx5WEviOgJkhVkIMIjgZJq3PsiFXluYeE9NTO/7JpiHP
 hlDcna6voTeVSGb2rBtm0qxNC3RHw8EhqPX0BH46WuonNrtWE8y1FdyN0Un38G+p54Q55Y5/
 7cOqAtkL1VVMcZYa90Ge9ES8qqDW7GRw7KLQupUBzaPbBCP2iIp4/84b0z6u3vcJsUzIEqkJ
 CES19cvX5aQTObNSRP5uw/zvngehTPYd228LAu23FQgMyNeJP7dSueVVspj8ys5/0CH8yzYY
 fABK5r
X-IronPort-AV: E=Sophos;i="5.96,145,1665460800"; 
   d="scan'208";a="83916859"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Nov 2022 10:48:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiZvIsKhsRrA9WZFlMP7vlxnZpLJ5a14drJb7Sko7+NBOI3z/w2aEfYGF1uBDI+FzqHzat5M5rHeWv9U96TYsiq2ch7u0/faepwkmBWULwMmkWrTnf1X4arQb843bwXN9tUsk5GgyjLWl+gIbl/ipPUj0ZVJeTLTk8ksW7v5gJIHAlQf5lWBq6qQ+KIieBDUIKmJJOcTBvxUF3kUCisg3u5FEt0hmsUroT5+7teSLwOAGM7K2d3nPHkQbPMdaVuRkQH9VyGjWf8Jt1Xz9ifxEOjKn4GIrc12+kE62tornIHUMtIslt8Xo02oslUzkmkwWvB+FYJ9h0JizX8SXME6xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Jg55OzpMfPWRymYQUUDXx34g4bLUHS5e5Afb3Zf+Ws=;
 b=KpInM2rlBlrrZv9ltfM/J9wx+k9D6rKsqdMaQ7tQzjObQ5F4ZhsKjDiBlwW+DAXKcBWMkHm41c0AeFylYT3MxwMXWJZnx9gw7GaiwJBq7hTtJ8Mc3IJZPvG45tylmETwOku25s2IEJw+nkQPTyiXUEWRfjyWGyia5C90P+7oRm+ehAPbfAX7TzlchDDx4bEBvNnJebAu+d48JYkCTkK/JqpnG8fOwCQoMQIYPUGnwYri/lSgE7VLSGpkjKDNIO2htKPeL6j4cxNSc2RcrQwD4vBK2VxcXP0QLxDKnV+u1MmxoPXpt2JkZpuFVUfq+ywtX+WdGi09gEXEFiyRUB4NoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Jg55OzpMfPWRymYQUUDXx34g4bLUHS5e5Afb3Zf+Ws=;
 b=ep7B2z7YsB1fl/nZ76A3qbiggNTlR69K/7K5XZZnET83sDYKmiurViMg86CUn5sXhMtnFVAr3u+2S9xmhk4zJw8UslbtVN1BLlbbrWPCJOAA22EXcGRherTyV5icr8yFnXWmZk29Qk0Jh6wkqnktjL6hUMWP3P0miZbF+H7J7xE=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by SJ0PR03MB5696.namprd03.prod.outlook.com (2603:10b6:a03:2d6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 15:47:59 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44%3]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 15:47:59 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "nathan@kernel.org" <nathan@kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 4/8] KVM: SVM: move guest vmsave/vmload to assembly
Thread-Topic: [PATCH 4/8] KVM: SVM: move guest vmsave/vmload to assembly
Thread-Index: AQHY8rjgcXsW5FU0l0OXUo54tNrBNq4zlr0AgAABnYCAAALSAA==
Date:   Mon, 7 Nov 2022 15:47:59 +0000
Message-ID: <b49e7568-9a9a-dd83-e15e-859d877c18cc@citrix.com>
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-5-pbonzini@redhat.com>
 <6c8539fa-38b5-d307-675a-2e272f7a83d3@citrix.com>
 <19c32786-6f5b-d438-269b-d29c104817ac@redhat.com>
In-Reply-To: <19c32786-6f5b-d438-269b-d29c104817ac@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR03MB3623:EE_|SJ0PR03MB5696:EE_
x-ms-office365-filtering-correlation-id: 2905128b-34cc-4416-993a-08dac0d77239
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ux5kktP+b+z7jErpMAjTJ+4Cs4ceZ0FKwmhqyofMpzYvja9Xi6OB+M9blQAZ7GsbU/4zCDSeW5c9BTDikHI6bNqm5axpEZNl/Ulh74fvoGn4jASsvC4TwvKvqG68Td/I9V2cfl+6Iaxuk/c8aQufdoi0OotbwmYbPBOQfqyQiSwebNRCRY6W/16L7Ys4k1/bCfgBFxoCwCe/RkB52XuDiN2pkcFBouxLIqZGNj1WDTGXtlfSbjZe0ymh0oluGQoZomxRp+TR9/vdggxiFULaesq4X1G2DkCBQ+kgI//+unzoXstATS3lKgepT9DcSMNK44x6ap+0VoYAMj7RUulrs8MaF6p7kSNcr0sijUXr4z0ysGJ5m+Pm7sKom/DXRKIWZede9u2LvEqDLBlGBouv/B4gQ8C57VmAjti2TwZ2PnlENqgBHMFIJC6M6gZ2xpGFjtHPIfgVxiesKkzk5Pd1rHkOqUaS8sFuG/vnbS9WpCQOxoweJVGzN1mIOq/mvW2xMOWOfEdNqcnKG3xZaNrY9a4qh+Km48Y9pkFNfXReU0Ck2bjjX0vz3v4yOLO7bAlRuVqfsRyCuCwyjuBO361pyH4lzlerdShaZWulbnh7oaSqfCX6+VgWuw3AriG4FUZYXcz+tVgY6hyWWqhCnlzMbLS6LTPaxdWe+YeQEGlSbNMNVlImM8PZJ7yXqpJKxY/H+EDLVMpQwTta/3e6X37leWJacfQtWhJCTlqUFs5tnA3QK4V10l6EfmlEaZ4oWFzipse5XS7mw7hbV07S16b45j0lT7cy5mbrDU17Rj9VOzykWQFmlI8qfBwa88154cToq5BrCgJCr8ya7i8qlBNZAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199015)(26005)(186003)(2616005)(6512007)(38100700002)(38070700005)(122000001)(82960400001)(76116006)(5660300002)(8936002)(2906002)(4744005)(53546011)(71200400001)(478600001)(6486002)(6506007)(66556008)(4326008)(66446008)(8676002)(66946007)(64756008)(66476007)(41300700001)(316002)(110136005)(54906003)(91956017)(31686004)(86362001)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDR4UzJoVVIxQ1dFTW9kYUxHN3dSK1RicjhCTFhERkVuc2JIMU1PZFltbTY1?=
 =?utf-8?B?dmpkRXhwaFVLa3Fid1NKKzZuUWprUERLdHdGSnhBWmtiVHZHb2dMQml6a2NC?=
 =?utf-8?B?dzNuS21STnozMFFobllRNDRZOFY4S0xkdzBaSG1aSnZyN2JMZVFYM3lUR2Rx?=
 =?utf-8?B?dWUzSTlMaXdVQ0s1SzlIbzVMdVo1T29BQTNPQ0F1dGZxc2lPV0VKVnNHK25W?=
 =?utf-8?B?bGw2SjRKeTgwVW0wN0NGa2pucVFISk0zR251RXRQejVLMm9WWVNnRk03UG1o?=
 =?utf-8?B?RzAxQjBySE9WS2JUMUNKcXRTY0JJanIxZzl1c2Y4akJrRXZOSTQ0aFpSdUtS?=
 =?utf-8?B?Q1A0dE5KVVdsQUJ6Y0t2eEVHODFvMGorZ1lzWi94bm9vN3Iyc2RKQ0p2dnAr?=
 =?utf-8?B?ZGdTVGlSTUZFUTBhZGx6Z294MFd1dEw0ckhtV2Ewd1pwU2lvK3d3RmQ1ZGJ0?=
 =?utf-8?B?NmFZZE4zb0VSeEtVNjlrQ0sxNUlhWEwrWllGK0MyWHNmL3poNmxPSGZtZklq?=
 =?utf-8?B?K2VmV0ZjY2t6c1lpeDlNaXEvN2hnNFVHNXdIU1RYRHEzY0lPQXMyN2VQY3gv?=
 =?utf-8?B?UGIvY0NVQ0hHQ0QwL0xmNlNsTnlWeGV6bDhLZ1FiZHZQU2JXMmlHKzBYYksr?=
 =?utf-8?B?OTh4TjdoK05vQlJNMEVpZnY2dUpWbGpPMTd2VDdGdE1lTSt3NGVvZnhIN2Vs?=
 =?utf-8?B?M3ZQZ0pnZHdZTVpuM0JZb1hJakFOa2p4QzFvSkxhRnlRQkZyNEUwMEFGR3Yv?=
 =?utf-8?B?bWhTZjcwQ0pnU0oxOEY2ZnNscE82bFFseDVmMmNXYnRKTTlMdjRhRHEyWWRk?=
 =?utf-8?B?dVJtSWhrcXplQTRieFlOUFpnL2F6MFlQL2dINGtxZ1VEZlBYWC85bXhlemFC?=
 =?utf-8?B?SmprTTFMZExEU0RHY2dKa21ESlFTWVBmUFFKWW1XT2dFN2dGRTNua1lqQ1hG?=
 =?utf-8?B?eTJCYTFjOHpQN093U2VSSlB3c2t0elJlRkJlWFl2ZHdmalZhRE5lc0kyUTkx?=
 =?utf-8?B?SGx3OXkwKzEyd1QyS25yRGQ5bnNvWXkyb1krOVAxR3RRSXpNdC9INDIvb3Vn?=
 =?utf-8?B?Qk00STcyOTNDYkdpaDF2RGw4bE1Ed0FFUTR2UXQ3c1Y5WG11bXhCUmFSZjhm?=
 =?utf-8?B?MjN1aVdlUjQvQnhyaGUwaUdLQUJHU2pUVnRtMkUzVGVnd0hralVseHBHdDYx?=
 =?utf-8?B?b0FTdnR0YVRwQmo4bHFTTkY1Um9rblJ0UkpLcElvTXZjVGU2dTlEZWQzcEZq?=
 =?utf-8?B?eVJnak1NUEhSSG5vQUN4eVBvMmZtMjlobEtWbTJKc2xmNlFmbVdaaXMrUGZ3?=
 =?utf-8?B?R3dmLzBrY1BYUzVEYVJxdmNpV3I0bUVMS1IxS0FrcWVJWTE5S3NkNExlZGdR?=
 =?utf-8?B?S1FHalhNTHd3QUxiODF0OWZUaURkb3BrK0tHMWxxTStkWkI3dmxVMXJKTk8w?=
 =?utf-8?B?S3RNdjRWYXpTNG9WS0FzM1ZFY2QxMGxRSTdiVy8rNGZBNmZHQ2JEdk5MMnNw?=
 =?utf-8?B?T2wxcTh1S1gvTWZ2ZXJhbFFYcHVJdXlaWFU1QWFCUXc0SFY5d3FpZlJwdDZi?=
 =?utf-8?B?OUkyOEhSMGUwMG5UY0VZcE1GQmcxZklQMTlENUxQcngyNUhqWXUvSHNNeG52?=
 =?utf-8?B?dGJseFp4bHJ2c2FPYTBCVU9zOGFaL0trMndhU2RJT1c4MFpxb3V3ZEcrVkNj?=
 =?utf-8?B?c0FiK1ZnbThDMTBzazdCOS9qT3pudkJJaEJCSzJGbmE4d0xGQ21sNzJpNEZw?=
 =?utf-8?B?Lys1NnpyR2c3M0M1a0Q3NkVoTkhhQlRNejQxSDZaNW8vZGtSYi94MTltb1JD?=
 =?utf-8?B?YVRHakZVdWMwTU1iNGROTmk1VVJzTzJnb3ZTd1NqeVRleVQ2TG9NdXVVMnJL?=
 =?utf-8?B?YVpRaGlTUlZlQjRTUzVtT1lzeHFjeGRaQmRudXpVYnNkM295NEtPa2VUUi9R?=
 =?utf-8?B?V0FoUjlyN3B2emV2MHlHbzBkRlN3N1RqZ09vUERFd0pYamJERW1BOU5oNFFM?=
 =?utf-8?B?T25WT0o1N1M4dXlmajhRZFF4c0RyUVNoSStSSVE0UVdEbWd2UDdWbFRNSCtu?=
 =?utf-8?B?NVZMbnlvVi9MVWlxTUtLR1IrRjNOOVJiSEdrL0tIaDBjK3VqbFNoRTAzSnRt?=
 =?utf-8?Q?9ebq4bm4ieMBlfDFh/QE+8pzF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95797690427C144F930FA1540F1338DF@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2905128b-34cc-4416-993a-08dac0d77239
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 15:47:59.2600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: szNgm1Elvs2WtxNszIGFOnjmeZDlSZGC+CEaR83MSWf+V0OFa1qwmp0j44vrBKnn8vbx1nqxzuqfrkdZMvTC6QiR2596QSCTvvAt6YigFNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB5696
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDcvMTEvMjAyMiAxNTozNywgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gT24gMTEvNy8yMiAx
NjozMiwgQW5kcmV3IENvb3BlciB3cm90ZToNCj4+PiAtwqDCoMKgwqDCoMKgwqAgdm1sb2FkKHN2
bS0+dm1jYjAxLnBhKTsNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgX19zdm1fdmNwdV9ydW4odm1j
Yl9wYSwgc3ZtKTsNCj4+PiAtwqDCoMKgwqDCoMKgwqAgdm1zYXZlKHN2bS0+dm1jYjAxLnBhKTsN
Cj4+PiAtDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHZtbG9hZChfX3NtZV9wYWdlX3BhKHNkLT5z
YXZlX2FyZWEpKTsNCj4+DQo+PiAlZ3MgaXMgc3RpbGwgdGhlIGd1ZXN0cyB1bnRpbCB0aGlzIHZt
bG9hZCBoYXMgY29tcGxldGVkLsKgIEl0IG5lZWRzIHRvDQo+PiBtb3ZlIGRvd24gaW50byBhc20g
dG9vLg0KPg0KPiBTdXJlLCB0aGF0J3MgcGF0Y2ggNiBpbiB0aGUgc2VyaWVzLsKgIFNlZSBhbHNv
IGNvdmVyIGxldHRlcjogInRoaXMNCj4gbWVhbnMgbW92aW5nIGd1ZXN0IHZtbG9hZC92bXNhdmUg
YW5kIGhvc3Qgdm1sb2FkIHRvIGFzc2VtYmx5Ii4NCg0KT2gsIG9rLsKgIEkgbWlzc2VkIHRoYXQg
aXQgd2FzIHNwbGl0IGFjcm9zcyB0d28gcGF0Y2hlcy4NCg0KU29ycnkgZm9yIHRoZSBub2lzZS7C
oCBUaGUgZW5kIHJlc3VsdCBsb29rcyBvay4NCg0KfkFuZHJldw0K
