Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35C32955ED
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 03:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894535AbgJVBEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 21:04:41 -0400
Received: from mail-dm6nam10olkn2075.outbound.protection.outlook.com ([40.92.41.75]:4385
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2442717AbgJVBEl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Oct 2020 21:04:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUjyTKiBy5Xp/sGHA93peDK8F7BuSIcPLM0EbY+TKVq2AqVhlgfxuq4fjMEPqjBOiUZ+6bmYy37tYbDJy82HUZil4+wOh1272L7VVwqUkeFTwqM45rD+UDitadfwnEczsgcNSZbvx65gEnWV+1PmaWIxCyy3DnbTXj0qyHkGxYLcdt/10+2iZJMVP6gKruPMenfB5gAd0MV4PFyH1fSUHgf+WC5QPhI1PzmWLSo8AGjeOgZijoJa4nI/3Mp2/wlTUtyA8bj6zzIcQ1pWNy3zOWfJ/GPrOkCWwQPYYHfsuCkBlkMpBrBVeh2/YUaSWpABkG8ZUwko3H0aIcRdtWOUng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6nL6C8ia6radyTLiojqmpX5ULH0vGvIdNt0fuDrejU=;
 b=i8d88fQseKhwSPEsoNVgHd3+wJQrse6Ovh/TN4Gmg1KtL/sQ3MmEbK2noYLmuymJW7VpNW0wUboc4oiYX6JhEw0ydei4B9sUHlkcDzHFO645wHTXb/GDHnUa+o6G6dfBZsmNxdzBSbCoIIZb/QdNQcWuSWr6+FgvTfDjIG6wgNnJg1ep2Zib+Yjdv08DmkWCbc/qy9W3Qdc+FqaSDNs6y7Eb9ZcXOpb3+BgPir09CdxuxLJf3jgukEe0rlzUvPnYutAl/oZVmgOuXux24uArayq2l5u0OhsmNs84qDu+1fPU4idTJ1902oxU8MN0SNXBotOji59Q/OUYZtP5fvmhZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=msn.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6nL6C8ia6radyTLiojqmpX5ULH0vGvIdNt0fuDrejU=;
 b=SqPQIkHGhBWCm4Ot2NnmaRdCGQSKpuwRHWU+ncG2cY6vzF6qfX27zuuiOotHEizTTFs/KWcyl24uVim1MW2a/3Pu5rorTgGNp4nzKe/oWL3MmUOxf7oWOITG6zBmrvViJm8P1KrVNKSc9KpG2UQAtbYBp9oqZAyalQK7E9PQ515j0TMbWceNSrGsDBWqHtC66o1mcNud+VxuihoY/CySFOZkWBe/SzoxUxQmt0iydw2QghIQkkVreVm66f8+cfV5ks0opld4dEt13nkPpsaLRz73sG5Bhl1SLgYu1QaYP5fJpaIjavB8WwrNduhAbcAizbKYwpDHvxQVeTwWTcxJVw==
Received: from DM6NAM10FT011.eop-nam10.prod.protection.outlook.com
 (2a01:111:e400:7e86::4d) by
 DM6NAM10HT164.eop-nam10.prod.protection.outlook.com (2a01:111:e400:7e86::263)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 22 Oct
 2020 01:04:39 +0000
Received: from DM6PR14MB2443.namprd14.prod.outlook.com
 (2a01:111:e400:7e86::51) by DM6NAM10FT011.mail.protection.outlook.com
 (2a01:111:e400:7e86::178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend
 Transport; Thu, 22 Oct 2020 01:04:39 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:DB135D4715C1840561BFE902885376569AECF1516CEE3C0584B3FD4DEF65DE8D;UpperCasedChecksum:F430B67D54011AF857FB4DDE6817769D74C2FED3AD97F6F53E1DEA6E7AD70D92;SizeAsReceived:7423;Count:46
Received: from DM6PR14MB2443.namprd14.prod.outlook.com
 ([fe80::a04c:3c4:bb6b:b3b4]) by DM6PR14MB2443.namprd14.prod.outlook.com
 ([fe80::a04c:3c4:bb6b:b3b4%7]) with mapi id 15.20.3477.028; Thu, 22 Oct 2020
 01:04:39 +0000
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Flava Rima
To:     stable@vger.kernel.org
From:   "Flava" <Rolf-Dieter5@msn.com>
Date:   Thu, 22 Oct 2020 01:04:34 +0000
Reply-To: flava091@gmail.com
X-TMN:  [2lbUanxl2tuvHhbbAuJZGOFxM8geX/Le]
X-ClientProxiedBy: MR2P264CA0021.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::33) To DM6PR14MB2443.namprd14.prod.outlook.com
 (2603:10b6:5:b1::20)
Message-ID: <DM6PR14MB244310EC255D467DF02883C5C11D0@DM6PR14MB2443.namprd14.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.4] (41.83.91.170) by MR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:1::33) with Microsoft SMTP Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.3499.18 via Frontend Transport; Thu, 22 Oct 2020 01:04:37 +0000
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 46
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 2f5176af-2738-479a-cee6-08d8762672ba
X-MS-TrafficTypeDiagnostic: DM6NAM10HT164:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2OBbZSi25NwJlY/1ApJRTcu3WjQXkqvoJxA5B1coxzhf+NGQNkyEJwZtUNKmkbLvSpQstkf/uNGqeATA/FlGYuS5SWuHp1iLFlnZNbu7kA8Nli+OAsqX4WadwqlRVYvDmpHlDrILI/ZRNBYLxAgquSJCCVVKU2NsVIr42YOvRGQQ3Aw2KEqzEks5ZkLclwmoJUsayz/4S0dtAe8KQkeKCQ==
X-MS-Exchange-AntiSpam-MessageData: nkJjUGAgIrB43W4Q3hSyOcNp45neIjk07UWMBJyXbSQAqT92nOUqWPYMT1ZqQA4WSD85isUTjyx8RWEIS3kCeFT/j+QwlpO7+FCcaL3WPs/2EAJczKTZGWg44gS+VsoSzraDd+Z8dc1eAszqx17RCQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f5176af-2738-479a-cee6-08d8762672ba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2020 01:04:39.3057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM10FT011.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6NAM10HT164
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

want to meet you, how are you?
