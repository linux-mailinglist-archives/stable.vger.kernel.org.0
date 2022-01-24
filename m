Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFA7498AC4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237293AbiAXTGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:06:42 -0500
Received: from mail-bn8nam11on2069.outbound.protection.outlook.com ([40.107.236.69]:20320
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345196AbiAXTDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 14:03:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1u8Jzx3TkkTNfK1iqPvd4UbMRgF1CO4/dGje5FLyCO2AsIE4cKpbWZqzBbK5RwzmfUvPiIGWwnPpYzNATWvLqxE7XqgW39ETEbWUatnkZzrmHyR4CC4h3K8L5Nn4XqPeWOD5D6vScuatHB9TkD3cM5sbPm1s3wcpcJpcyviCWxomv7EquS218BDuvHTtpDtArJnKlcQ+sBOZYSnilKpiwvtvKYoTe5H3Oz9bACjI5W2I6VjPNj4/6IOBEGzfnXs9QXND8o605sR4VsThgxDZKFADJpsxv86YSkfB75FRjVVY1VvvdrvNF7xesDmpAvCTc3O172giJEew+JGZFS1Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6vcO6RycWfPOWC1l8Bc/1II3UMGcFgcrYTAzYAgx57o=;
 b=W96rKAdzCEUd3L5dZNiJXa0nlOLwlwxz15e3d+vR5kfLU+53a2GF1JgPaav0UWjC4KQbOhDWj0HPAWbgtt4T5KvDtAw+P3/yT7NEl5B0w3meYaWYi3p5+ZLKa8KbodS098mV3/J05AwpbF75gpSRSPKJPRQkkTj8eaXZF2XwbGiDXF8DWeDuFQHnKyNBstxesiarZIHHfVRVKNYhqtlBa/w91U9drt4hMzlcLF+OkNMle9VZES5qc3Cf3+JJzIBN4SHm+CJ9Y4EDf6ivlK+SGRIyqIf4+TnHToIQzGc8ZJalnsFK/7kB9OOfj18SjzTLDz3GEFt8fYm5kwA7KB0BFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vcO6RycWfPOWC1l8Bc/1II3UMGcFgcrYTAzYAgx57o=;
 b=SQwoZ7M3u0oW7LM2apBlnW+/a0EN55wGnckGv36jlcOAB4Ojlx0XGILNLNKgn/cwTiL/+HSkLscD0igUe1Hal/l2CQhcF1gDhU5uBdaV7vJCRRo/xY9zaUqcENbvLk5y1CNXEr2hZpz/2vsyG5z6AxZGLUjR7GVEeutRqa2eGQs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by DM6PR12MB3545.namprd12.prod.outlook.com (2603:10b6:5:18b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Mon, 24 Jan
 2022 19:02:59 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 19:02:59 +0000
Message-ID: <1df3a6ae-b6c1-adb4-48b8-49139cab8772@amd.com>
Date:   Mon, 24 Jan 2022 13:02:57 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     stable@vger.kernel.org
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
Subject: SMU "failures" on s0i3 for DCN31
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0261.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::26) To BL1PR12MB5157.namprd12.prod.outlook.com
 (2603:10b6:208:308::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9dd8bda-5676-4dc2-500c-08d9df6c2379
X-MS-TrafficTypeDiagnostic: DM6PR12MB3545:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3545EB41113DDE8693362920E25E9@DM6PR12MB3545.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AN4gtmTDbeOVCCXqEh27eiKSVm+i7+W5Ekxi52MEWUOsdZta4pNUkyzN5DhOkHFyvVE8ugREvKGmiznT5zY/5MdJKl8WVPGy180+Cth2zypePv/WPdXdpmVXSLdytz3/N3OdyIpuEhxtICk3OUlIYded3bnkkr2qgrvZ0OZgm5YTlo9fRCw8EkZddTQN3oGT4iViq3ZDyUKpCPD0g/ybb/8bGJwSWQl2JpzOUvfQ+HcBnWBbfzD6cP4AylorK38nesKo6tJT8BdVWPoT/uorSupOtSPqy321v2OOe3mqg4qwc+/P/tvhWiSKC9HiXISZGvi8HiPe8EJGyCmRlUl12MXuFPf6g5BHCVJHBEjVkHVPIsOoiUyb2oPzmIm7DIBA17mv9VRC3yGju4C4M49TYO4da9juUz2d7/JPWCRcWulUZdlTJjr1aR5KbNPAf4R/219uGtwz0B9zjLRfgx5VGyaJ0jbj2b58FLiLkVGJkdqFk2B+Asc9YPlzc+ffMt6klR/RIgUiZUNx8GsxoY1+QpqqHxfWqupvm0yPFQDmOuJWQGUMjMYnLboZsaus2KYhw+kh1IQaew/3AqFawLUSO25dnBB+qhtVlkSMEHZhb+/zkyrkN3ON8SBCE8lhqbepZqh0rcCc2TPyFf46ZhqSkXnVm1jHVYznCuwHzxwHQnh/HzMi8ZuFYZSyI50MUz/BKTU18QO6wICq2BZ43RQ3kYaDuE4qquO8SQP73UiDf8kbsxQDD2S4zKU5gqG1rVtA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(6916009)(31686004)(2616005)(8936002)(5660300002)(36756003)(38100700002)(186003)(26005)(6506007)(8676002)(6512007)(66476007)(316002)(6486002)(508600001)(558084003)(83380400001)(66556008)(31696002)(66946007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkpQVVZXTGhSYkhqY1p4Nzc5aFVwdEFURjV1L2M3S0UvbzFBSXF4MU5ZVE5Y?=
 =?utf-8?B?M05yMlZwbmlDNkVPb2JPamxIeTlISXFtcWVLR3VvS21GY29Ea1hnU2Jvdk1Y?=
 =?utf-8?B?WTU2VTVTZjBJeXc0a3AvQW1TejFuVkV4L01vT0xPU0dpVWtSZFBPcGlDejlY?=
 =?utf-8?B?ZlZWMVV2UHlMdTlKcVJjMTFoNWR1alBGVDV6SkxnTWpPQzJBMmtXRFpxeW91?=
 =?utf-8?B?TUVjTHF5YzRRSEJWMlF4VjdpQzYzWmw0TEE2NVpDcGplUHNYTnhxRjFqYVN0?=
 =?utf-8?B?UFVBbXJqdk9vbVBEU1dhSW5ic3RDZ3Z3YWZnbWVUcThCMFQzQjdRbEpFaWVk?=
 =?utf-8?B?ZFQ1bUpwZW9BSzVyd01xNXFDUkRDOTJ2QkowQ0swNS8yZUxHWDhWM0lwSTlk?=
 =?utf-8?B?eWh1dml2T3o0OUdxZmN2dzhkN3YrMGRobXRMTXIrQnhpRkt3K2Y0N083eXFm?=
 =?utf-8?B?RUJGaHlWNE9BVzA1TWRNbWtBUUN2dlZ6WndLSmd4S1YrWWR4V0xZMEVqKzhW?=
 =?utf-8?B?cE9OcE9xMW45LzVnZXJYQjJwSUhUZFlzYXVHOWZ2SElZOHUybVZMVWZjZERt?=
 =?utf-8?B?NHY5aEhBNEtOOFhSMkhxYkV6d3k4UG9QeTZRTWVTbzhuMzlTclFyc1Y5ayti?=
 =?utf-8?B?ZnQrS2VlaEVLRHBVVERGTVBXekJ2TWp5ZGFOamlPeU95YkN3RlJoN0hWNUFh?=
 =?utf-8?B?cldPQ3BTZExXV3hHd09TVzJGYVFHOElLN0F4QWprTXNaNGhlSmZmWXFQZkp0?=
 =?utf-8?B?NEJVbTBUZWczNkhETEFtVllpSG5BZmdibVZ1T0d3ZlVTaFI2bzBSc0MwNmt2?=
 =?utf-8?B?TDk3d25aVUxwcGVEdFFjZ2tQbXdUTHlNUlR1bWJRUGFSWjdXY2tZSEJGRDhi?=
 =?utf-8?B?YUVORUNVdzhzT1hEeDYwTzh5ME8wYjlDM29lNmpZRGNjakh4TnhVZzFOZFlU?=
 =?utf-8?B?K1dHNzlobTZhdEFvRHZsQjM2Z3pJWkZVbXBHZU1WTEo2QThTYTErZUw1eDl3?=
 =?utf-8?B?WDhjTE13cHNqLzErdzFsYzM0d29PYXhYWTBBUDhmSGN6YlJDeHV4bGNML0ti?=
 =?utf-8?B?YVVWaVJWVzdBcE5Cd2VqL2FLM0ptNlZOd1dNT20xOXpEWG5IdHpFRmtJS0E1?=
 =?utf-8?B?UVVoN2hPZ2s0K2V2SWdYb3pYOWhHb1U4MG91akcyNEJnMVpTK0ZiTXZPbUpm?=
 =?utf-8?B?SjZiTTlZSHVaTHhEcVZEcGVObnkxSjRERDh0REh0Y2xYcENpSHFacXNFaE9k?=
 =?utf-8?B?eWZYSlhMc3VlUFllM2lRaUkwY1FMYWtjd2syT0I3aU14cVJtV3hJRzF4WE14?=
 =?utf-8?B?TjBkc3ozUE1pZTgwQjVLUUdRanBSN3RyV1g3ZlNPdGt2a3ptc21CSGxJNXlL?=
 =?utf-8?B?ZFVTb05TZHJCYnNLZjkzU0haWjBoRktKUVNzak1LS3NpVk5PUzBHT0hQR054?=
 =?utf-8?B?NEJXTDBkbHBqdzc3ZnRsM3hsSDNHZ3pyRXlWdnBHRHNvTERTQlg3eUdVdEV6?=
 =?utf-8?B?d2ZJb0JjckpEQkxXbStDNi84STl3ck10QU5qVEhOeEIyNnlOZEVEUTV6emhi?=
 =?utf-8?B?SzBLMUVrM2dmQzRiSU9NWTRDT1BNSENWcG8vTmI0dk05ajdaZVRQR0FVRDh2?=
 =?utf-8?B?Y1RKNTlmVGdFNFZ5ZDkydVBOOWlqSnNOOGR5SGN3TFRESGY0OHE3a3N2bXRm?=
 =?utf-8?B?eGdCTG9hRzVGSW94cGVabVJrelA0eTE5T1drc2VpeTZTblIwUnY1cEFCNEZi?=
 =?utf-8?B?eGZUUmZock1nYys2L3pLeHdmWEhNVzM1a1prd2dMRkZLM0V3U0RETEdPeFow?=
 =?utf-8?B?Z3hiOHYrMGwzTHV3NkUxOFB0WDVkZ1dMU0ZkM3ZmaDgvUWVxTmkxcG9kNFRo?=
 =?utf-8?B?VmJ4VE9CK3ZuRURkem1mS0JoeFhvUjIzZ0YybEw5eTJSVUJwaWQ5RlpXU1dk?=
 =?utf-8?B?RlR3Syt0NGhLUk85YytGNkFPVFFpZkNUNXo5cGFuL2lFVG1iQmo3NG5ZU2lR?=
 =?utf-8?B?eFZ6QUMwUklPN0tkaVR1cmVJTGk0ZVlHKzcrclNyZ2N6cHRiZWw2eGxjSFBF?=
 =?utf-8?B?YnBacGFzR2MzRGZoNDNtb1NGaXJPbm0yNFdCV0p0OGhLRG0vWTQzRE0rMXF0?=
 =?utf-8?B?bU5TVjRRZGRPVTdvc2VWMU54d3ZpR2xmMmRPMXczMzExNnlyQUJweTFEU0Ey?=
 =?utf-8?Q?+gHcvYko2susQgehtNlge0E=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9dd8bda-5676-4dc2-500c-08d9df6c2379
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 19:02:59.5188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4Ukk+HmA8JML/4xQYljyBmQnjp+RLf3S7jOGENI/8Ci8kLYI8iHD7QkEsk14pZ8DaAqMpbugEx/cPYssyhMfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3545
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can commit 83293f7f3d15fc56e86bd5067a2c88b6b233ac3a ("drm/amd/display: 
reset dcn31 SMU mailbox on failures") please come back to 5.15.y and 
5.16.y?  This will make identifying and recovering potential FW problems 
easier.

Thanks,
