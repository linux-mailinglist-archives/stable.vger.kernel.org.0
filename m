Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4376B644F4F
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 00:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiLFXIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 18:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLFXIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 18:08:44 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-mr2fra01on2070.outbound.protection.outlook.com [40.107.9.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD4141986;
        Tue,  6 Dec 2022 15:08:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRu/2jyR7QQ6zIJAwSpvHAVJ3erbbHYh4xeBlGFwc5Qo+Tv7AJroQ8E6GjUR5Kbe7giypUvPEWuZ73eiTeAEO8yLp6LoNV9UB+sfF7u4MWu1yqcN4B9DVSpVt14DqxTYIiIb7yDXLA8syid8zgMlyjzib+uURSu0Ch/HBVdgWhvSZnMRDasfz010AEG9V/p8Ry/RPj5j5Y+HS9HzsfCgZJ0tzK5RZXnUPKoR2MGqoshaO+dcDXz/2pCk7IqKxecHlJRWugY9clEd5xRH8zHwCjWXjYelVnwv5TmWLnjH6IZJeH65IxzqxC86t4tPNZR+jNaPVBdj8leP7hVd9Oodgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qCySpL2tXEmsen3D/JM10joOXmR9BQhNU7c9SP5nqk8=;
 b=jYDZo15ZO389iuz3CmTHZalNjYSNZbR8X9vATmI6SygDjSMa2PlfZLVyLrKKlsDhwzf+fmF2BuGiqY57wWK9k4rCt/FmAtEEP5k3xmGdlnFBCucL3qyIHkvRCF+bBqS9xL6JDzjed4waUvgkzQ6BPv14gYDCqQ+8DiAA3gvD7cqPqsG0kA66TMvB2v/QPvbtyA0nHTQMXo05nBJIrbRsVlKlBAFkXjrRZpbdG4MZDqVqO/fq45Pyzjf627Z3W1nFj8vkttoXhZh4r43NYaTT+mVjuIhdWl3CCfA9048bASX5yHbtbd/lhqWWA2RCYl/2kICU8KuXVz0Y1WXkLx4DLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qCySpL2tXEmsen3D/JM10joOXmR9BQhNU7c9SP5nqk8=;
 b=r0R1X8Ew9bJKkLz86d87hb7KJe0tH/zMlMouLZ2giMGIBJt9/n1mLLgVQgr0vcT6ZQKapP0jwmDAP364KbX4Aamr6IKII0Uz1KXXIxuhrJefZDZt5UaKjMSOhKv/1XpxHTnpfddgqIjWop7JLLLRf3YOQpxiXfKr/j3nQiaQQZB5+pfLLjFdg9AWmA2TUVieyIwpIpfkdImlhDkYZBWM/3Z+rjrIa4xRmvUbKZHsxy549VvcF8OCcHoxl4RTnCvMtEmXhVkLyM0LawFIFw5vVB7Y78UN61M5AkqeSy+XzmS9q1Jy8p21LNAiJOptfT+BeJLTZQGcSyRy9TO8Q5bp1w==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB2032.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1b2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 23:08:40 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::a85b:a9b6:cb36:fa6]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::a85b:a9b6:cb36:fa6%9]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 23:08:40 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Jeanson <mjeanson@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Suchanek <msuchanek@suse.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Thread-Topic: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Thread-Index: AQHZBaANAqqRYC4fWEmzGmz7Z31vrK5ey1WAgADVqwCAAApsAIAAFL6AgAAamACAABHWAIABCOKAgACOoQA=
Date:   Tue, 6 Dec 2022 23:08:40 +0000
Message-ID: <5522ee0a-f7b6-9342-93bf-7ecbc59071ba@csgroup.eu>
References: <20221201161442.2127231-1-mjeanson@efficios.com>
 <87pmcys9ae.fsf@mpe.ellerman.id.au>
 <d5dd1491-5d59-7987-9b5b-83f5fb1b29ee@efficios.com>
 <219580de-7473-f142-5ef2-1ed40e41d13d@csgroup.eu>
 <323f83c7-38fe-8a12-d77a-0a7249aad316@efficios.com>
 <dfe0b9ba-828d-e1a5-f9a3-416c6b5b1cf3@efficios.com>
 <87mt81sbxb.fsf@mpe.ellerman.id.au>
 <484763aa-e77b-b599-4786-ef4cdf16d7bd@efficios.com>
In-Reply-To: <484763aa-e77b-b599-4786-ef4cdf16d7bd@efficios.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PR1P264MB2032:EE_
x-ms-office365-filtering-correlation-id: 0378e09e-62bf-41b9-f362-08dad7ded053
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ye+CRjROFkcmunAUOfW1IhM1e7n2dPqRFxCrodBiGPkHVS5kBPPNuBTU/V0PIJn7dQbLUqjtRvINcEmxceaxmSQkHeg4F+0M8Fa3LCHdeKcFmS8eZ99SDXiO/ZSHiClyZd+Is+P8jszi7cbSYzadbPcElRfN0kl+iyiOSRRpnkl5ffbun/HvHf89AjamhvQganw3vRAk5ZjRz0eT+ilt0ha1dvx4WytKOTK7u97hLCZSWw2Z51+XpaTHIkRcuquprwJOofofZfiX5feCKpxvTNStDSRwHgKMj47/Ld7Ao7vVGLpJ3qWv8w5ju0X4gXYYLPsvg8HyVWolIWFhyuy1FgZCkrsSUkvmmnaahn6sEXeG6nnaGy051lAsNJHWJUcQBXXDS7lpC1ZhR60m8hcMqkcn+9iHjQcz+kLjhdhXmDo7CtjaPZ643nDZ/e/m7UtPdHoFUEgqCi+syIPR37trVooGEz8r93FZXdc82/BvORHbXBB7b8+xxIwdd8re0ppio3I7tp3/9GbtAZf2LsH54SXaQ2g04psHp2VUb+F2INqkbkIM8v7e7Z2jlic0mONk9Uic1jDDvPEIJXzbj5H0UmBaUYliQDx2tah6cv6dO2npDjmo/Z9k8Pj/sH/XSMOwsZZFIIKV03XB6uZTH31tV0IS2/jwozmhHDZQYGO570KjIOdc08RWEDzp9xyaeSmnetoQV9J4op9AU8bLP5YSFKTA8CSnlXzIyow0NTZPhPjs91q2/2juSx/vpItMCx/FVt2AYS+4lvcgUxcLQCBnEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199015)(41300700001)(38100700002)(186003)(66574015)(2616005)(2906002)(478600001)(38070700005)(83380400001)(5660300002)(122000001)(36756003)(8936002)(44832011)(7416002)(53546011)(6506007)(6486002)(31686004)(71200400001)(76116006)(91956017)(86362001)(66446008)(31696002)(66556008)(66476007)(8676002)(64756008)(66946007)(26005)(6512007)(316002)(54906003)(4326008)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1pnTTNuMmV6OVk0ZHJLOExocU5XZjlxc1pENzFXU1paWEJTYnFua2NHZGwx?=
 =?utf-8?B?MFJHUXdwL0pyYTRXeCsvVVkrVlhDdWp2WVBxRnJUd2xPVjZnQ2dmV2w2b3o4?=
 =?utf-8?B?dE9qU21qVWg5WjRLUHRVeUcxZ2VFUVlITTJYT2pPcFhyS1BmdFh1QTIwN3JM?=
 =?utf-8?B?aE0ycXV2bUlKRzBMRy91aXNaVHp1VVBwT1MyR2V3UGZ5UTlrQTRBNExMcVFt?=
 =?utf-8?B?YlRMODdEejcza25qSFdiR3hvaHA3R1MzWlg0ZUx0WUZqT09PTFJCNC9XZ0wz?=
 =?utf-8?B?bWFGWWlrU3YyL2lZQ3ZEdkl0SzE0MUZnRk1qT2pwMUVCOFdUeEQ5M09Kc2Js?=
 =?utf-8?B?REJwbXl5TVNwZVk0NSt1Qlo2V2Z3T3hDZDhmNlFIdzhuT3FaK01qQXVGbjZj?=
 =?utf-8?B?RjJhYzRxNGRCYmtPdGVtMzZYaWRBZnRFQ08vT2IwdnNtUFJRNGpuTDFJK2Yw?=
 =?utf-8?B?TldRY2lySU81dExtQTF5WUVwVTFhd1YySEcwWEZkMlJER01ZVllCcllXc1JS?=
 =?utf-8?B?ZUhrZ0VTTWx1cVUzL09nOXphWkdaK0o1czhod0FQRWh1c0pxSG0zT3BwS05p?=
 =?utf-8?B?ZVdnZ3dRRkEwK1NuSnZ4QVdwUUg0dFFOcXlBU1JzTkV6RGdxK0tocmk0anFt?=
 =?utf-8?B?UGFRZWlCemdWVEtCc29rZmJHVGhVUXZtaDhlYU9iOFJDWm14WFRzeEsvUmdv?=
 =?utf-8?B?bE1SM0wyUk9nbUUzQVdrSG1GaGRVSzk3Y1Z0R0tzdHFjTUhDM2JyNmtsUlY4?=
 =?utf-8?B?OHUvS0cxWnRRK0xjVHZYYmpSditoL3BQWWtnTVdCcTBzK3RJQVRmMlZtUXNG?=
 =?utf-8?B?czhnN0tYMjkraUFocndZRWtKM2hDR3NRQVdCK29QVVRTdkl6MXFQTTRid3FO?=
 =?utf-8?B?VzBGNjlOeWlLQy84ZjdWMU9qTlErSVROTHdrUnRuOTdhMU9CTk4wM25UZVhn?=
 =?utf-8?B?UGZoS0U2MlVCUWt3eUJMUk1BZ3JwMzN4U0Y5a2lWVjZDWkNlNG1DOVhXZ3FE?=
 =?utf-8?B?RjIzVjVxQ2RXY2doNS9mUGJtdFRvVUFoSW1vdFBjdXpIR3FsNjlFLzZBUjdZ?=
 =?utf-8?B?czgyTXhsZUVoUTJTNlR5VVM2QWRENGV5VDdtVGgrVDFKeUFQT2pQOUNKT3pl?=
 =?utf-8?B?cmVQV3gzQkNWUWlpL0VNanFQd0ZydGQxTzJoQ0dPNlFUdC9MQUFnL1ZESTly?=
 =?utf-8?B?blRQUWs3ZW51aFVRUXN1NldyQ085RnV5Tmc2VDdzSDFmRlpWK1JGZXBGTW41?=
 =?utf-8?B?bFJXM254eHFHcUNibWhTbEoyb2lYUlA1aTJiVjlWZ0E2aHRiNURHQW0rRTJV?=
 =?utf-8?B?ck02SlFMaEphRk00K0FyTTZETlRrMEZTdFhqWDZ1Q0dUd2VsVE0zQ09tK2FW?=
 =?utf-8?B?bmpvS2FPZ3JNRTloVjV2WkV2cysyU2o2QVdRV1lVc3E1ZlBmVHVKRllzV1ND?=
 =?utf-8?B?RW8rWGU2Q3Q1WCt1K0dIT2VydlI2WUVOcmZiOVNwWTg3cDdIeTVBTG5WMFdD?=
 =?utf-8?B?RlBJa2xybEZQV1cxQUpRR2xsekFSRDdhVzlHWTZZTGJzdWdJVzROTXBEWjRv?=
 =?utf-8?B?TVh6L01RNUZhVDEvNGp0Q2c5aFI1cjM1ODdOZkhvTENpeEpmaGRMOWowb0o1?=
 =?utf-8?B?LzhTSEFTK3BMellDRklkNHFSVXZQL1NqVldNODN1ZnBQMURQbEZDY3YrS0dW?=
 =?utf-8?B?aGpuQWYxUmRqQzQwMkFuUS9haTd5aFBGdHp5QVQ0S1dPOStCR0ViVHdiWjJF?=
 =?utf-8?B?Q3BsSFJVZTRqcTZLYTR3SVBWQkFNT2FJUW9ORjBETXR2RjVuVVVka2cwV1g0?=
 =?utf-8?B?QXpLaWlNWHVxU0hKaGMyK3IyZlNsR2pzWkgxaFh2L1hjelZ5NWgwclE3V2F3?=
 =?utf-8?B?VTMxeUl2QWtOT3JYT0JhcGxLNUdkVEwyWW5GamdkMkR4czJkYjE5M3BuK21M?=
 =?utf-8?B?dFdFOVBPR1ZwQUNxMkRMTTk1U0RzbEx3TkwvRU5vTzRjMk5IaVhmejYzL1Ez?=
 =?utf-8?B?NFlzMXZPSng4MlZXNGNzTDNhTjZhREJxTXBjcWR4V2JvL3VCelJ1VWR2WGcv?=
 =?utf-8?B?T0xoZW5ScTZlbkMrd1JCUUpKZjduMXVoSW5XZEUxSWdaeFVaZXN4cUk3cTZC?=
 =?utf-8?B?SFFkRTdYN3RRK01rWG5pMDRnUlExNXdVNUh3UFBBL0lFdXhiMUozaG9rNmRG?=
 =?utf-8?B?Q1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABEC945FE52F7E4891E9A044C92836AC@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0378e09e-62bf-41b9-f362-08dad7ded053
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 23:08:40.3751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 59rQs5VQ4n2Njld5LGyDO4eaBzaAUU3wvju75mUaYI2cYQUijX0mrwn4zpkvwiOahmUTMdDo4iYHE82PBgz2AWt+75NGnp3bPXpxL5AEXzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB2032
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDA2LzEyLzIwMjIgw6AgMTU6MzgsIE1hdGhpZXUgRGVzbm95ZXJzIGEgw6ljcml0wqA6
DQo+IE9uIDIwMjItMTItMDUgMTc6NTAsIE1pY2hhZWwgRWxsZXJtYW4gd3JvdGU6DQo+PiBNaWNo
YWVsIEplYW5zb24gPG1qZWFuc29uQGVmZmljaW9zLmNvbT4gd3JpdGVzOg0KPj4+IE9uIDIwMjIt
MTItMDUgMTU6MTEsIE1pY2hhZWwgSmVhbnNvbiB3cm90ZToNCj4+Pj4+Pj4gTWljaGFlbCBKZWFu
c29uIDxtamVhbnNvbkBlZmZpY2lvcy5jb20+IHdyaXRlczoNCj4+Pj4+Pj4+IEluIHY1LjcgdGhl
IHBvd2VycGMgc3lzY2FsbCBlbnRyeS9leGl0IGxvZ2ljIHdhcyByZXdyaXR0ZW4gaW4gQywgb24N
Cj4+Pj4+Pj4+IFBQQzY0X0VMRl9BQklfVjEgdGhpcyByZXN1bHRlZCBpbiB0aGUgc3ltYm9scyBp
biB0aGUgc3lzY2FsbCB0YWJsZQ0KPj4+Pj4+Pj4gY2hhbmdpbmcgZnJvbSB0aGVpciBkb3QgcHJl
Zml4ZWQgdmFyaWFudCB0byB0aGUgbm9uLXByZWZpeGVkIG9uZXMuDQo+Pj4+Pj4+Pg0KPj4+Pj4+
Pj4gU2luY2UgZnRyYWNlIHByZWZpeGVzIGEgZG90IHRvIHRoZSBzeXNjYWxsIG5hbWVzIHdoZW4g
bWF0Y2hpbmcgDQo+Pj4+Pj4+PiB0aGVtIHRvDQo+Pj4+Pj4+PiBidWlsZCBpdHMgc3lzY2FsbCBl
dmVudCBsaXN0LCB0aGlzIHJlc3VsdGVkIGluIG5vIHN5c2NhbGwgZXZlbnRzIA0KPj4+Pj4+Pj4g
YmVpbmcNCj4+Pj4+Pj4+IGF2YWlsYWJsZS4NCj4+Pj4+Pj4+DQo+Pj4+Pj4+PiBSZW1vdmUgdGhl
IFBQQzY0X0VMRl9BQklfVjEgc3BlY2lmaWMgdmVyc2lvbiBvZg0KPj4+Pj4+Pj4gYXJjaF9zeXNj
YWxsX21hdGNoX3N5bV9uYW1lIHRvIGhhdmUgdGhlIHNhbWUgYmVoYXZpb3IgYWNyb3NzIGFsbCAN
Cj4+Pj4+Pj4+IHBvd2VycGMNCj4+Pj4+Pj4+IHZhcmlhbnRzLg0KPj4+Pj4+Pg0KPj4+Pj4+PiBU
aGlzIGRvZXNuJ3Qgc2VlbSB0byB3b3JrIGZvciBtZS4NCj4+Pj4+Pj4NCj4+Pj4+Pj4gRXZlbnQg
d2l0aCBpdCBhcHBsaWVkIEkgc3RpbGwgZG9uJ3Qgc2VlIGFueXRoaW5nIGluDQo+Pj4+Pj4+IC9z
eXMva2VybmVsL2RlYnVnL3RyYWNpbmcvZXZlbnRzL3N5c2NhbGxzDQo+Pj4+Pj4+DQo+Pj4+Pj4+
IERpZCB3ZSBicmVhayBpdCBpbiBzb21lIG90aGVyIHdheSByZWNlbnRseT8NCj4+Pj4+Pj4NCj4+
Pj4+Pj4gY2hlZXJzDQo+Pj4NCj4+PiBJIGRpZCBzb21lIGZ1cnRoZXIgdGVzdGluZywgbXkgY29u
ZmlnIGFsc28gZW5hYmxlZCBLQUxMU1lNU19BTEwsIHdoZW4gDQo+Pj4gSSByZW1vdmUNCj4+PiBp
dCB0aGVyZSBpcyBpbmRlZWQgbm8gc3lzY2FsbCBldmVudHMuDQo+Pg0KPj4gQWhhLCBPSyB0aGF0
IGV4cGxhaW5zIGl0IEkgZ3Vlc3MuDQo+Pg0KPj4gSSB3YXMgdXNpbmcgcHBjNjRfZ3Vlc3RfZGVm
Y29uZmlnIHdoaWNoIGhhcyBBQklfVjEgYW5kIEZUUkFDRV9TWVNDQUxMUywNCj4+IGJ1dCBkb2Vz
IG5vdCBoYXZlIEtBTExTWU1TX0FMTC4gU28gSSBndWVzcyB0aGVyZSdzIHNvbWUgb3RoZXIgYnVn
DQo+PiBsdXJraW5nIGluIHRoZXJlLg0KPiANCj4gSSBkb24ndCBoYXZlIHRoZSBzZXR1cCBoYW5k
eSB0byB2YWxpZGF0ZSBpdCwgYnV0IEkgc3VzcGVjdCBpdCBpcyBjYXVzZWQgDQo+IGJ5IHRoZSB3
YXkgc2NyaXB0cy9rYWxsc3ltcy5jOnN5bWJvbF92YWxpZCgpIGNoZWNrcyB3aGV0aGVyIGEgc3lt
Ym9sIA0KPiBlbnRyeSBuZWVkcyB0byBiZSBpbnRlZ3JhdGVkIGludG8gdGhlIGFzc2VtYmxlciBv
dXRwdXQgd2hlbiANCj4gLS1hbGwtc3ltYm9scyBpcyBub3Qgc3BlY2lmaWVkLiBJdCBvbmx5IGtl
ZXBzIHN5bWJvbHMgd2hpY2ggYWRkcmVzc2VzIA0KPiBhcmUgaW4gdGhlIHRleHQgcmFuZ2UuIE9u
IFBQQzY0X0VMRl9BQklfVjEsIHRoaXMgbWVhbnMgb25seSB0aGUgDQo+IGRvdC1wcmVmaXhlZCBz
eW1ib2xzIHdpbGwgYmUga2VwdCAodGhvc2UgcG9pbnQgdG8gdGhlIGZ1bmN0aW9uIGJlZ2luKSwg
DQo+IGxlYXZpbmcgb3V0IHRoZSBub24tZG90LXByZWZpeGVkIHN5bWJvbHMgKHRob3NlIHBvaW50
IHRvIHRoZSBmdW5jdGlvbiANCj4gZGVzY3JpcHRvcnMpLg0KPiANCj4gU28gSSBzZWUgdHdvIHBv
c3NpYmxlIHNvbHV0aW9ucyB0aGVyZTogZWl0aGVyIHdlIGVuc3VyZSB0aGF0IA0KPiBGVFJBQ0Vf
U1lTQ0FMTFMgc2VsZWN0cyBLQUxMU1lNU19BTEwgb24gUFBDNjRfRUxGX0FCSV9WMSwgb3Igd2Ug
bW9kaWZ5IA0KPiBzY3JpcHRzL2thbGxzeW1zLmM6c3ltYm9sX3ZhbGlkKCkgdG8gYWxzbyBpbmNs
dWRlIGZ1bmN0aW9uIGRlc2NyaXB0b3IgDQo+IHN5bWJvbHMuIFRoaXMgd291bGQgbWVhbiBhY2Nl
cHRpbmcgc3ltYm9scyBwb2ludGluZyBpbnRvIHRoZSAub3BkIEVMRiANCj4gc2VjdGlvbi4NCj4g
DQo+IElNSE8gdGhlIHNlY29uZCBvcHRpb24gd291bGQgYmUgYmV0dGVyIGJlY2F1c2UgaXQgZG9l
cyBub3QgaW5jcmVhc2UgdGhlIA0KPiBrZXJuZWwgaW1hZ2Ugc2l6ZSBhcyBtdWNoIGFzIEtBTExT
WU1TX0FMTC4NCj4gDQoNClllcywgc2VlbXMgdG8gYmUgdGhlIGJlc3Qgc29sdXRpb24uDQoNCk1h
eWJlIHRoZSBvbmx5IHRoaW5nIHRvIGRvIGlzIHRvIGFkZCBhIG5ldyByYW5nZSB0byB0ZXh0X3Jh
bmdlcywgDQpzb21ldGhpbmcgbGlrZSAodW50ZXN0ZWQpOg0KDQpkaWZmIC0tZ2l0IGEvc2NyaXB0
cy9rYWxsc3ltcy5jIGIvc2NyaXB0cy9rYWxsc3ltcy5jDQppbmRleCAwM2ZhMDdhZDQ1ZDkuLmRl
Y2YzMWM0OTdmNSAxMDA2NDQNCi0tLSBhL3NjcmlwdHMva2FsbHN5bXMuYw0KKysrIGIvc2NyaXB0
cy9rYWxsc3ltcy5jDQpAQCAtNjQsNiArNjQsNyBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBsb25n
IHJlbGF0aXZlX2Jhc2U7DQogIHN0YXRpYyBzdHJ1Y3QgYWRkcl9yYW5nZSB0ZXh0X3Jhbmdlc1td
ID0gew0KICAJeyAiX3N0ZXh0IiwgICAgICJfZXRleHQiICAgICB9LA0KICAJeyAiX3Npbml0dGV4
dCIsICJfZWluaXR0ZXh0IiB9LA0KKwl7ICJfX3N0YXJ0X29wZCIsICJfX2VuZF9vcGQiIH0sDQog
IH07DQogICNkZWZpbmUgdGV4dF9yYW5nZV90ZXh0ICAgICAoJnRleHRfcmFuZ2VzWzBdKQ0KICAj
ZGVmaW5lIHRleHRfcmFuZ2VfaW5pdHRleHQgKCZ0ZXh0X3Jhbmdlc1sxXSkNCg0KLS0tDQpDaHJp
c3RvcGhlDQo=
