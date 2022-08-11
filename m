Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD75058F596
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 03:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbiHKBfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 21:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiHKBfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 21:35:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC3243310
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 18:35:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Re2PKdrOKTPIW6vqe0NszXSd9yn2MW0HDXpTcmgtbyusT5OeEi1bY/kOIPQZLAnQ3T4mgrn3oyy26lvO5mM0tI7zznzNEkgvpGIs3rZHPF5HDRNdquO6i00LTvFLqv+adfq9E+amfIJTHjmDc0iaQE3dfXfdcQ/BoJpf5Rnpe1mG0rWpBbJKAe53HNvro9nm5NiV6GkjUXLg4J5xFI70yo845XaRaOZxTvSl0DGQFaqNCGJkMl9sRGrlaaUJ/fVmmWEpvHTYsW89Imw6hnfZy7WqaRxQgYA7QhV8ztBZiAnM8+UYoKLOvT7+07EspqbLWEmfJWsx6ZG8QLpBLcScKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Aiymnq1NH4B5mnG4o1sD9IrDiqDEMC+l/UWsoLWuZg=;
 b=Y5Ys++F4zY+IOQA2vdPj2GGXjLSDrfYBpJkzUEMsQFZ5nZ2cx7s0Msd+zeGjZb8/tT7HzsPvL9y/nOklJKNVI3st0qF49zYPQcJI8jmTkp8eaVdX0v1wLx0/EI3ctB0qsuIaqK7fbRaQt6MuLLMhT3f0k9jX2mVYg5CEWdmPHSfQUC13zwmAtRdgNGGldm0jDXH7Vvyym966AzMWVxcKCAtl2vaDljpVfqGWEBAQwXHL77ejCOUHSbtxrboib67XR1PCeFS9770VDlI9dPmLyo89D97+29TxydLROI5Z8Gmn+Z8MlRFMCVycr9aML2C5SI5cwDwkmPT1J0gs8O4aLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Aiymnq1NH4B5mnG4o1sD9IrDiqDEMC+l/UWsoLWuZg=;
 b=zIhX7/zf/yKjlNLSLt9DMEpeBFAO/lzwaJt54kOvzlYKirPJRkqHW2Ld4UDS40UZGw1NEwhfP3f54MnFiWKdGTLMaOH3OZhK3m8dzCNoot+XVRUsJGWxqtoUTjltG2p2Kj71EZVUApxcxfqMR++CY/3wV7/yrK9M1vKtlVIJ7gc=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM5PR12MB2389.namprd12.prod.outlook.com (2603:10b6:4:b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Thu, 11 Aug
 2022 01:35:30 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::4489:9a98:ef82:6c67]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::4489:9a98:ef82:6c67%3]) with mapi id 15.20.5504.021; Thu, 11 Aug 2022
 01:35:30 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Fix microphone on some Lenovo laptops
Thread-Topic: Fix microphone on some Lenovo laptops
Thread-Index: AditIhQCgu/KAwrrQXud/PLr4cqOrA==
Date:   Thu, 11 Aug 2022 01:35:30 +0000
Message-ID: <MN0PR12MB6101E6F7B146642A3E424D76E2649@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-08-11T01:32:16Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=f9c7f699-abd4-4f6b-a60f-52309cab67f5;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-08-11T01:35:27Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 76f9d865-2769-4402-9620-477369810366
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ba91e81-8957-4dd2-032b-08da7b39c68b
x-ms-traffictypediagnostic: DM5PR12MB2389:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KY5eOVHhyQ009oVq5DpaPlldHZkD+7XB+Ov0JRAS0bB7cK3T95oCrFyCiB8AN6Y+L+mCkRX3oJtrLejohFVV/F+2XXtHbx4aBRhEliMHvO1FqfxSaQQyxzEFodClrIN/sq/qQ2wGY3UyPsIjahkfxYROUIokXIDyrkxyZVU5cYEK/0L3WYX97Niym7STbKhfwWZHeyX5jkBgwp5yulsqLp+AQCm/zgZ+YjwV8ZWxTamuYq25F8D61eitJEnZ1qihonnKW+gB7uIH1wkJlVP2DgXPtakLazpOh/7ZYtgtzz292ekoaPPpUZTWHau1jJBMaNpwJw6OZy0RdVTglJEMQ+QYeiW8L0lPDQSBB1RgZ4nPgZt0bBppPsjfllouwTolahig8VmnDWY3Wex3OY7FKeFEynzYhPap4R9b4AdjMdK1G+leME9yqDAxIVZbeAFeM+T4tQmBn1Uf92SkMp79B/M3lhn7GASRWfGdMQrzSmc0RufExqpKMIgshMpVoHsh1z82KCyvh8lFSndTnkhQLGZplQQC5OSXxqm5ZKTHIoY/poBcHemZS0pniIsZXHQIj1OAW9xGHHtjYYSfk0HD5lHbzsrnFFvoUibAmUSq421uu2RR8scv3bEorzB770yaIFM06fHhn/BRqz72xhhJ2Kx9o+6SquxcIVNTl2kG38F+BuPkFVmMH7L++1r2++xMVKnFxXe5S0svRaLai4ItMUqoKKflG/ORDfaJ/NoM3rCrUX2HVnxfylcmjQx5lbxocuFu28WQjylY0f9i8LTn5/cnNUzne+EJ7nFsNcQdzKQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(6916009)(64756008)(66476007)(5660300002)(66446008)(66556008)(316002)(76116006)(8676002)(66946007)(86362001)(55016003)(7696005)(558084003)(8936002)(122000001)(52536014)(83380400001)(2906002)(33656002)(186003)(38070700005)(38100700002)(71200400001)(478600001)(9686003)(41300700001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xay+N14a0ZyIXIItXlUGjSjGjlV8LvkvIZrAPjGFilXW93TJFa4dkFuI9dbu?=
 =?us-ascii?Q?J6PvFDYz+8HSxJ2/9mc9qD7fsq90M5lfcusuf+ZWDD90GLx8SVLW1ZxXBl1j?=
 =?us-ascii?Q?xYfsOR6ENgL/ODqtmC2TF6BUhYqwgpJP+HluryuBYcwrA8SoxyFmvhxrqhXr?=
 =?us-ascii?Q?yIoV0vY9MRYcY771fMxgOvWEq0lCyp1L0VxSYx0lk5nALPuW7RiHnmTJq7VI?=
 =?us-ascii?Q?H5H2DRX6S5x0a7RcqIuauQ+8S5HnrShCd19E18Hao9GJBp9BApNRA4o+AizW?=
 =?us-ascii?Q?xSbqkVnz1GUZ7TuUscHJAFGqe5C06gzAviEiM8bHNslRWYYed5vHjDSFQN+X?=
 =?us-ascii?Q?bVOaG9BXEiabspvMb9hXtIaLvYPhs/SRaxA7pll2MWjj2i7nI5bL7/lYVuHg?=
 =?us-ascii?Q?8wN4tPICq5O4T8Ast0PvyrO6Mo6rRYbno4hjw/ukOZfHcNjUSz/cq8j5HA/p?=
 =?us-ascii?Q?Fjcg9wB2UJ5s4ZsZonr0NtySowq0q2wCZYtvT1Gowz1ObiENPmBaJ2XKMh/X?=
 =?us-ascii?Q?vu/Gvyxrpe6LbBBxa2J8kxgxsJQ5sWUHHrGBVVe8qVOLvyldHgg/jduV6dCC?=
 =?us-ascii?Q?SH1HwxMeUdqWiET0ycfR7KLXRzbKy6HRbfPz+vizV1UI6ugP6/reJktS9zHu?=
 =?us-ascii?Q?XlipujTDkmmDefYT6I5NQkjY71nmF7PV1Hwg7ePG4aQqGUpTYIwqQRRJ+COD?=
 =?us-ascii?Q?EnOp19z7kFcaQyWQUhFBrXmJ6f7IS6KXfmXov1yZcBJSeEVpCIeanwWQSc9S?=
 =?us-ascii?Q?TBcriLefuHDJMNxBNAbNwbYwQck1Pwf/KpcR5YOxEelL1EeSgwBqRN7IyTLk?=
 =?us-ascii?Q?MyL2coBy9NjIbsgC2CbOUPlEH86a1783UuSGNReXPOxWT80+qq8FAYmA8KJP?=
 =?us-ascii?Q?pH05BAKYMQAlZy6eFFdxb6UDgkQAj5L2kEC3J8JR0rvmSzEb1yACBCVg4MLM?=
 =?us-ascii?Q?zpeGqHSwzFsdIaKBPOgNU47kWXdlH9nrnUIWofKbALTGWBmBfe5EnJySO1rd?=
 =?us-ascii?Q?XnJgXd0jiBJq0jpy3la/DwsKtfCvs068qqOHEdoX/w9Eiuxmdv8cFWVnSPBw?=
 =?us-ascii?Q?RoUFSZMkeBAm57R1XisM1e/KntiNRC3vjxEMjnb2MiyQ8F5Bvoz69W6tycxV?=
 =?us-ascii?Q?EkqZ7fQQWCSgdFYfGrLh5Z2bhUQ43KjgroDmbuSDFdALQb8TNlUmybiVKesL?=
 =?us-ascii?Q?/JYolqmwbJ38Bbcm3w1In0dGf/bwobNQhgiUey399GpJrsblRpo30E7pyKwH?=
 =?us-ascii?Q?PuetgofJM3MmyjX2uLAeOUDmWtYFph9FqRwmHcPZ/4yujIxk3pwLt2gLiK6D?=
 =?us-ascii?Q?UT28t9Kl0BWt2Y8BNuEd3Q5BAESr/5spwwbDSZ6VJD0gMr3N/H00DOgE+o6w?=
 =?us-ascii?Q?CV8PWF6UiAsnI6bg9CWjZPWp/8v0RqZI/sKSUu4uanYf6sKUUOnXWYIIax3z?=
 =?us-ascii?Q?8lHwTjagaJxiQMJkrIzJMmmgO/2Bi+IpnL+UzUxcrqPWEtJtjUV8JoTMmbYc?=
 =?us-ascii?Q?9JB/qTyFXSenqHGej1Qg22aLrM1tFsHgogvlWPIlEtxDNHCA99FNQF1tuaKy?=
 =?us-ascii?Q?kn56u+DEOws9zaGydZg+j/vPBygyDrojK9+ZmmiwmO4zB+z5zjI5zGWnZURx?=
 =?us-ascii?Q?ZvURCZ1DV0UdgeHJd25x9NM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba91e81-8957-4dd2-032b-08da7b39c68b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 01:35:30.0541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NcbBTOZbCoF/GzJ8XHQw4A5RTKef5GaYWuTFLIpAPm/cXN5Ojn0oI0sIQ8GkL3b6mt8HWprP1ayK7n/T9TVIWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2389
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

Some Lenovo laptops need to be added to an ACP6x quirk list for the DMIC on=
 them to work.
Can you please backport this commit to 5.18.y and 5.19.y?

be0aa8d4b0fc ("ASoC: amd: yc: Update DMI table entries")

Thanks,
